import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/chat_cubit.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/repositories/chat_repository.dart';

class ChatScreen extends StatefulWidget {
  final int nutritionistId;
  final int patientId;
  final String? patientName;

  const ChatScreen({
    super.key,
    required this.nutritionistId,
    required this.patientId,
    this.patientName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().initialize();

    _scrollController.addListener(() {
      // Load more when scrolled to top
      if (_scrollController.position.pixels <= 100 && !_isLoadingMore) {
        _loadMore();
      }
    });
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    await context.read<ChatCubit>().loadMoreMessages();
    setState(() => _isLoadingMore = false);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    context.read<ChatCubit>().sendMessage(content);
    _messageController.clear();

    // Scroll to bottom after sending
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.patientName ?? "Chat"),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoaded) {
                  return Text(
                    _getConnectionStatus(state.wsState),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getConnectionColor(state.wsState),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.orange,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ChatLoaded || state is ChatLoadingMore) {
                  final messages = state is ChatLoaded
                      ? state.messages
                      : (state as ChatLoadingMore).currentMessages;

                  if (messages.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline,
                              size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            "No hay mensajes aún",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Text(
                            "Envía el primer mensaje",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      if (_isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final isMe = message.senderId == widget.nutritionistId;
                            final showDate = _shouldShowDate(messages, index);

                            return Column(
                              children: [
                                if (showDate)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      _formatDate(message.timestamp),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                _buildMessageBubble(message, isMe),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                return const Center(child: Text("Iniciando chat..."));
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageModel message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Escribe un mensaje...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              maxLines: null,
              maxLength: 1000,
              buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                if (currentLength > 900) {
                  return Text(
                    "$currentLength/$maxLength",
                    style: TextStyle(
                      fontSize: 11,
                      color: currentLength >= 1000 ? Colors.red : Colors.grey,
                    ),
                  );
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              final canSend = state is ChatLoaded &&
                  state.wsState == WebSocketState.connected &&
                  _messageController.text.trim().isNotEmpty;

              return IconButton(
                onPressed: canSend ? _sendMessage : null,
                icon: const Icon(Icons.send),
                color: Colors.blue,
                disabledColor: Colors.grey,
              );
            },
          ),
        ],
      ),
    );
  }

  bool _shouldShowDate(List<ChatMessageModel> messages, int index) {
    if (index == 0) return true;

    final current = messages[index].timestamp;
    final previous = messages[index - 1].timestamp;

    return current.day != previous.day ||
        current.month != previous.month ||
        current.year != previous.year;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return "Hoy";
    } else if (messageDate == yesterday) {
      return "Ayer";
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  String _getConnectionStatus(WebSocketState state) {
    switch (state) {
      case WebSocketState.connected:
        return "Conectado";
      case WebSocketState.connecting:
        return "Conectando...";
      case WebSocketState.disconnected:
        return "Sin conexión";
      case WebSocketState.error:
        return "Error de conexión";
    }
  }

  Color _getConnectionColor(WebSocketState state) {
    switch (state) {
      case WebSocketState.connected:
        return Colors.green;
      case WebSocketState.connecting:
        return Colors.orange;
      case WebSocketState.disconnected:
      case WebSocketState.error:
        return Colors.red;
    }
  }
}

