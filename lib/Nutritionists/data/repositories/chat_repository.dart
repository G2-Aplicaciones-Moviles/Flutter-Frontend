import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../../../iam/services/auth_session.dart';
import '../models/chat_message_model.dart';

enum WebSocketState { disconnected, connecting, connected, error }

class ChatRepository {
  static const String baseUrl = "http://10.0.2.2:8080";
  static const String wsUrl = "ws://10.0.2.2:8080/ws";

  StompClient? _stompClient;
  WebSocketState _state = WebSocketState.disconnected;
  final StreamController<WebSocketState> _stateController = StreamController.broadcast();
  final StreamController<ChatMessageModel> _messageController = StreamController.broadcast();

  int _reconnectAttempts = 0;
  Timer? _reconnectTimer;

  Stream<WebSocketState> get stateStream => _stateController.stream;
  Stream<ChatMessageModel> get messageStream => _messageController.stream;
  WebSocketState get currentState => _state;

  /// Fetch message history
  Future<List<ChatMessageModel>> history(
    int nutritionistId,
    int patientId, {
    String? cursor,
    int limit = 50,
  }) async {
    final token = await AuthSession.getToken();

    try {
      String url = "$baseUrl/messages/$nutritionistId/$patientId?limit=$limit";
      if (cursor != null && cursor.isNotEmpty) {
        url += "&cursor=$cursor";
      }

      final res = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((json) => ChatMessageModel.fromJson(json)).toList();
      } else if (res.statusCode == 401) {
        throw Exception("Sesión expirada. Por favor inicia sesión nuevamente.");
      } else if (res.statusCode == 403) {
        throw Exception("No tienes permiso para ver estos mensajes.");
      } else if (res.statusCode == 404) {
        return []; // No messages found
      } else if (res.statusCode >= 500) {
        throw Exception("Servicio no disponible. Intenta más tarde.");
      }

      return [];
    } catch (e) {
      print("Error fetching message history: $e");
      if (e is Exception) rethrow;
      return [];
    }
  }

  /// Connect to WebSocket
  Future<void> connect(int userId) async {
    if (_state == WebSocketState.connected || _state == WebSocketState.connecting) {
      return;
    }

    _updateState(WebSocketState.connecting);

    final token = await AuthSession.getToken();

    try {
      _stompClient = StompClient(
        config: StompConfig(
          url: wsUrl,
          onConnect: (_) => _onConnected(userId),
          onWebSocketError: (error) => _onError(error, userId),
          onStompError: (frame) => _onError(frame.body, userId),
          onDisconnect: (_) => _onDisconnected(userId),
          webSocketConnectHeaders: {
            'Authorization': 'Bearer $token',
          },
          stompConnectHeaders: {
            'Authorization': 'Bearer $token',
          },
          heartbeatIncoming: const Duration(seconds: 20),
          heartbeatOutgoing: const Duration(seconds: 20),
        ),
      );

      _stompClient!.activate();
    } catch (e) {
      print("Error connecting to WebSocket: $e");
      _onError(e, userId);
    }
  }

  void _onConnected(int userId) {
    print("WebSocket connected for user $userId");
    _reconnectAttempts = 0;
    _updateState(WebSocketState.connected);
    _subscribePrivate(userId);
  }

  void _onDisconnected(int userId) {
    print("WebSocket disconnected");
    _updateState(WebSocketState.disconnected);
    _scheduleReconnect(userId);
  }

  void _onError(dynamic error, int userId) {
    print("WebSocket error: $error");
    _updateState(WebSocketState.error);
    _scheduleReconnect(userId);
  }

  void _scheduleReconnect(int userId) {
    _reconnectTimer?.cancel();

    // Exponential backoff: 2s, 5s, 10s
    final delays = [2, 5, 10];
    final delayIndex = _reconnectAttempts.clamp(0, delays.length - 1);
    final delay = delays[delayIndex];

    _reconnectAttempts++;

    print("Scheduling reconnect in ${delay}s (attempt $_reconnectAttempts)");

    _reconnectTimer = Timer(Duration(seconds: delay), () {
      if (_state != WebSocketState.connected) {
        connect(userId);
      }
    });
  }

  void _subscribePrivate(int userId) {
    if (_stompClient == null || !_stompClient!.connected) return;

    _stompClient!.subscribe(
      destination: '/user/$userId/queue/messages',
      callback: (frame) {
        if (frame.body != null) {
          try {
            final data = jsonDecode(frame.body!);
            final message = ChatMessageModel.fromJson(data);
            _messageController.add(message);
          } catch (e) {
            print("Error parsing message: $e");
          }
        }
      },
    );

    print("Subscribed to /user/$userId/queue/messages");
  }

  /// Send a message
  void send({
    required int senderId,
    required int recipientId,
    required String content,
  }) {
    if (_stompClient == null || !_stompClient!.connected) {
      print("Cannot send message: WebSocket not connected");
      return;
    }

    if (content.isEmpty || content.length > 1000) {
      print("Invalid message content length");
      return;
    }

    final message = ChatMessageModel(
      senderId: senderId,
      recipientId: recipientId,
      content: content,
      timestamp: DateTime.now(),
    );

    _stompClient!.send(
      destination: '/app/chat',
      body: jsonEncode(message.toJson()),
    );

    // Add to local stream for immediate UI update
    _messageController.add(message);
  }

  /// Disconnect WebSocket
  void disconnect() {
    _reconnectTimer?.cancel();
    _stompClient?.deactivate();
    _stompClient = null;
    _updateState(WebSocketState.disconnected);
  }

  void _updateState(WebSocketState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  void dispose() {
    disconnect();
    _stateController.close();
    _messageController.close();
  }
}

