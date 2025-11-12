import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/primary_button.dart';
import 'patient_progress_screen.dart';

class PatientDetailScreen extends StatelessWidget {
  final String name;
  final String goal;
  final String avatar;

  const PatientDetailScreen({
    super.key,
    required this.name,
    required this.goal,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Paciente'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: .5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(avatar, height: 140, width: 140, fit: BoxFit.cover),
                ),
                const SizedBox(height: 16),

                _infoField('Nombre', name),
                _infoField('Objetivo', goal),
                _infoField('Altura', '1.63 m'),
                _infoField('Peso', '65 kg'),
                _infoField('Nivel de actividad', 'Ligeramente activo'),

                const SizedBox(height: 20),
                PrimaryButton(
                  text: 'Mandar mensaje',
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                PrimaryButton(
                  text: 'Ver Progreso',
                  outlined: true,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PatientProgressScreen(name: name),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade800)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(value, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
