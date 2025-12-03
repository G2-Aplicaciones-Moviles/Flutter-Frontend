import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/repositories/chat_repository.dart';

// States
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessageModel> messages;
  final WebSocketState wsState;
  final bool hasMore;

  ChatLoaded({
    required this.messages,
    required this.wsState,
    this.hasMore = true,
  });

  ChatLoaded copyWith({
    List<ChatMessageModel>? messages,
    WebSocketState? wsState,
    bool? hasMore,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      wsState: wsState ?? this.wsState,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}

class ChatLoadingMore extends ChatState {
  final List<ChatMessageModel> currentMessages;
  ChatLoadingMore(this.currentMessages);
}

// Cubit
class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;
  final int nutritionistId;
  final int patientId;

  StreamSubscription? _messageSubscription;
  StreamSubscription? _stateSubscription;
  bool _hasMore = true;

  ChatCubit({
    required ChatRepository repository,
    required this.nutritionistId,
    required this.patientId,
  })  : _repository = repository,
        super(ChatInitial());

  Future<void> initialize() async {
    emit(ChatLoading());

    try {
      // Load initial history
      final messages = await _repository.history(nutritionistId, patientId, limit: 50);
      _hasMore = messages.length >= 50;

      // Connect WebSocket
      await _repository.connect(nutritionistId);

      // Subscribe to incoming messages
      _messageSubscription = _repository.messageStream.listen((message) {
        final currentState = state;
        if (currentState is ChatLoaded) {
          // Only add if it's relevant to this chat
          if ((message.senderId == nutritionistId && message.recipientId == patientId) ||
              (message.senderId == patientId && message.recipientId == nutritionistId)) {
            final updatedMessages = List<ChatMessageModel>.from(currentState.messages)
              ..add(message);
            emit(currentState.copyWith(messages: updatedMessages));
          }
        }
      });

      // Subscribe to WebSocket state changes
      _stateSubscription = _repository.stateStream.listen((wsState) {
        final currentState = state;
        if (currentState is ChatLoaded) {
          emit(currentState.copyWith(wsState: wsState));
        }
      });

      emit(ChatLoaded(
        messages: messages,
        wsState: _repository.currentState,
        hasMore: _hasMore,
      ));
    } catch (e) {
      emit(ChatError("Error al inicializar chat: $e"));
    }
  }

  Future<void> loadMoreMessages() async {
    final currentState = state;
    if (currentState is! ChatLoaded || !_hasMore) return;

    emit(ChatLoadingMore(currentState.messages));

    try {
      final oldestMessage = currentState.messages.first;
      final cursor = oldestMessage.id?.toString();

      final olderMessages = await _repository.history(
        nutritionistId,
        patientId,
        cursor: cursor,
        limit: 50,
      );

      _hasMore = olderMessages.length >= 50;

      final allMessages = [...olderMessages, ...currentState.messages];

      emit(ChatLoaded(
        messages: allMessages,
        wsState: currentState.wsState,
        hasMore: _hasMore,
      ));
    } catch (e) {
      emit(currentState); // Revert to previous state
    }
  }

  void sendMessage(String content) {
    if (content.trim().isEmpty || content.length > 1000) return;

    final currentState = state;
    if (currentState is! ChatLoaded) return;

    if (currentState.wsState != WebSocketState.connected) {
      emit(ChatError("No conectado. Esperando reconexión..."));
      // Revert after showing error
      Future.delayed(const Duration(seconds: 2), () {
        if (state is ChatError) {
          emit(currentState);
        }
      });
      return;
    }

    _repository.send(
      senderId: nutritionistId,
      recipientId: patientId,
      content: content.trim(),
    );
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _stateSubscription?.cancel();
    _repository.disconnect();
    return super.close();
  }
}

