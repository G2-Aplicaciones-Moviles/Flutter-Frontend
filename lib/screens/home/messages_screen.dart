import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/primary_button.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final consultations = [
      {
        'name': 'Jefferson Rojas',
        'avatar': 'https://randomuser.me/api/portraits/men/22.jpg',
      },
      {
        'name': 'Jhonatan Rodriguez',
        'avatar': 'https://randomuser.me/api/portraits/men/44.jpg',
      },
    ];

    final plans = [
      {
        'name': 'Cristina Perez',
        'avatar': 'https://randomuser.me/api/portraits/women/25.jpg',
      },
      {
        'name': 'Patricia Benavides',
        'avatar': 'https://randomuser.me/api/portraits/women/28.jpg',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mensajería'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: .5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),
          const Text('Consultas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          ...consultations.map((p) => _chatItem(context, p)).toList(),
          const Divider(height: 24),
          const Text('Planes de alimentación',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          ...plans.map((p) => _chatItem(context, p)).toList(),
        ],
      ),
    );
  }

  Widget _chatItem(BuildContext context, Map<String, dynamic> p) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(p['avatar']),
          radius: 24,
        ),
        title: Text(p['name']),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 4),
          child: PrimaryButton(
            text: 'Mensaje',
            outlined: true,
            small: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    name: p['name'],
                    avatar: p['avatar'],
                  ),
                ),
              );
            },
          ),
        ),
        trailing: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, color: Colors.green),
            SizedBox(width: 8),
            Icon(Icons.remove_circle_outline, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
