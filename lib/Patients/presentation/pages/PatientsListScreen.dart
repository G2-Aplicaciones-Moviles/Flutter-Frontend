import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jameofit_flutter/Patients/presentation/pages/PatientsDetailScreen.dart';

import '../../../iam/services/auth_session.dart';
import '../bloc/PatientsBloc.dart';
import '../../data/models/NutritionistPatientModel.dart';
import 'PatientsRequestsScreen.dart';

class PatientsListScreen extends StatefulWidget {
  const PatientsListScreen({Key? key}) : super(key: key);

  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  final PatientsBloc patientsBloc = PatientsBloc();

  @override
  void initState() {
    super.initState();

    () async {
      final nutritionistId = await AuthSession.getNutritionistId();
      patientsBloc.add(FetchPatientsEvent(nutritionistId!));
    }();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientsBloc, PatientsState>(
      bloc: patientsBloc,
      builder: (context, state) {
        if (state is PatientsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PatientsErrorState) {
          return Center(child: Text(state.message));
        }

        if (state is PatientsLoadedState) {
          final List<NutritionistPatientModel> acceptedPatients =
          state.patients.where((p) => p.accepted == true).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PatientsRequestsScreen()),
                      );

                      final nutritionistId =
                      await AuthSession.getNutritionistId();
                      patientsBloc.add(FetchPatientsEvent(nutritionistId!));
                    },
                    child: const Text("Solicitudes Pendientes"),
                  ),
                ),
              ),

              Expanded(
                child: acceptedPatients.isEmpty
                    ? const Center(child: Text("No tienes pacientes aún."))
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: acceptedPatients.length,
                  itemBuilder: (context, index) {
                    final p = acceptedPatients[index];
                    final profile = p.profile;

                    return _PacienteCard(
                      nombre: "Paciente ${p.patientUserId}",
                      objetivo:
                      "Objetivo: ${profile?.objectiveName ?? 'Sin objetivo'}",
                      programa: p.serviceType,
                      accepted: p.accepted,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PacienteDetailScreen(paciente: p),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _PacienteCard extends StatelessWidget {
  final String nombre;
  final String objetivo;
  final String programa;
  final bool accepted;
  final VoidCallback onTap;

  const _PacienteCard({
    Key? key,
    required this.nombre,
    required this.objetivo,
    required this.programa,
    required this.accepted,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final badgeColor = accepted ? Colors.green : Colors.orange;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.blue[300],
              child: const Icon(Icons.person, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 12),

            // Información del paciente
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    objetivo,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Badge del tipo de servicio
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                programa,
                style: TextStyle(
                  fontSize: 11,
                  color: badgeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
