import 'package:flutter/material.dart';
import '../../data/models/NutritionistPatientModel.dart';

class PacienteDetailScreen extends StatelessWidget {
  final NutritionistPatientModel paciente;

  const PacienteDetailScreen({Key? key, required this.paciente})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = paciente.profile;

    return Scaffold(
      appBar: AppBar(
        title: Text(profile?.objectiveName ?? "Paciente"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.blue[300],
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 50),
                  ),
                  const SizedBox(height: 20),

                  _buildInfoField("Género", profile?.gender ?? "--"),
                  const SizedBox(height: 16),

                  _buildInfoField("Altura", "${profile?.height ?? '--'} m"),
                  const SizedBox(height: 16),

                  _buildInfoField("Peso", "${profile?.weight ?? '--'} kg"),
                  const SizedBox(height: 16),

                  _buildInfoField("Actividad",
                      profile?.activityLevelName ?? "Sin datos"),
                  const SizedBox(height: 16),

                  _buildInfoField(
                      "Objetivo", profile?.objectiveName ?? "Sin objetivo"),
                  const SizedBox(height: 16),

                  _buildInfoField(
                    "Alergias",
                    (profile?.allergyNames.isNotEmpty ?? false)
                        ? profile!.allergyNames.join(", ")
                        : "Ninguna",
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botón Mensaje
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A92FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Mandar mensaje',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Botón Progreso
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF4A92FF), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Ver Progreso',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A92FF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
