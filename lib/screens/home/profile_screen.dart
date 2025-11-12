import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(radius: 35, backgroundImage: AssetImage('assets/images/logo.png')),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dra. María López', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Nutricionista Especializada en Nutrición Deportiva', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              ElevatedButton(onPressed: null, child: Text('Editar Perfil')),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Especialidades', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('Nutrición Infantil')),
              Chip(label: Text('Nutrición Deportiva')),
              Chip(label: Text('Cambio de Hábitos')),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Tus Certificaciones y logros profesionales.'),
          ),
          const SizedBox(height: 24),
          const Text('Mis Servicios', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ServiceCard(
                  title: 'Consulta Personal',
                  price: '\$50',
                  duration: '1 hora',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ServiceCard(
                  title: 'Programa de Dieta',
                  price: '\$100',
                  duration: '30 días',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  child: const Text('Guardar Cambios'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String price;
  final String duration;

  const _ServiceCard({
    required this.title,
    required this.price,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title),
            const SizedBox(height: 4),
            Text(duration, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
