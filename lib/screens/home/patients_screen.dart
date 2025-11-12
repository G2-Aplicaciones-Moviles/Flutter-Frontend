import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/primary_button.dart';
import 'patient_detail_screen.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final searchCtrl = TextEditingController();

  final List<Map<String, dynamic>> patients = [
    {
      'name': 'Sofía Martínez',
      'goal': 'Pérdida de peso',
      'service': 'Programa de dieta',
      'avatar': 'https://randomuser.me/api/portraits/women/65.jpg',
    },
    {
      'name': 'Sebastian Rodríguez',
      'goal': 'Aumento de masa muscular',
      'service': 'Programa de dieta',
      'avatar': 'https://randomuser.me/api/portraits/men/70.jpg',
    },
    {
      'name': 'Carla Torres',
      'goal': 'Consulta personal',
      'service': 'Consulta personal',
      'avatar': 'https://randomuser.me/api/portraits/women/45.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pacientes'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: .5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Buscador
            TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar paciente',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => searchCtrl.clear(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pacientes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final p = patients[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(p['avatar']),
                      radius: 24,
                    ),
                    title: Text(p['name']),
                    subtitle: Text(p['goal']),
                    trailing: Text(
                      p['service'],
                      style: const TextStyle(color: Colors.green),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PatientDetailScreen(
                          name: p['name'],
                          goal: p['goal'],
                          avatar: p['avatar'],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              text: 'Solicitudes pendientes',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
