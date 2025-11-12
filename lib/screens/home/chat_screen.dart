import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String avatar;

  const ChatScreen({super.key, required this.name, required this.avatar});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController msgCtrl = TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {'text': 'Buenas tardes', 'isMe': true},
    {'text': 'Buenas tardes', 'isMe': false},
    {'text': '¿A qué hora estarías disponible para la consulta?', 'isMe': true},
    {'text': 'Mañana a las 13:00 me encuentro disponible', 'isMe': false},
  ];

  void _sendMessage() {
    final text = msgCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'text': text, 'isMe': true});
    });
    msgCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.avatar)),
            const SizedBox(width: 10),
            Text(widget.name),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: .5,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg['isMe'] as bool;
                return Align(
                  alignment:
                  isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.blueAccent.shade100
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft:
                        isMe ? const Radius.circular(12) : Radius.zero,
                        bottomRight:
                        isMe ? Radius.zero : const Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      msg['text']!,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input de mensaje
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgCtrl,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu mensaje',
                      filled: true,
                      fillColor: Colors.blueAccent.shade100.withOpacity(0.3),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
