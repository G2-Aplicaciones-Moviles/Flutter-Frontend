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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Paciente",
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue[400]!,
                          Colors.blue[600]!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue[300],
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 56),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildInfoField("Género", profile?.gender ?? "--"),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoField(
                            "Altura", "${profile?.height ?? '--'} m"),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoField(
                            "Peso", "${profile?.weight ?? '--'} kg"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  _buildInfoField("Actividad",
                      profile?.activityLevelName ?? "Sin datos"),
                  const SizedBox(height: 14),

                  _buildInfoField(
                      "Objetivo", profile?.objectiveName ?? "Sin objetivo"),
                  const SizedBox(height: 14),

                  _buildInfoField(
                    "Alergias",
                    (profile?.allergyNames.isNotEmpty ?? false)
                        ? profile!.allergyNames.join(", ")
                        : "Ninguna",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A92FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: const Color(0xFF4A92FF).withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.message_outlined, size: 20),
                label: const Text(
                  'Mandar mensaje',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF4A92FF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}