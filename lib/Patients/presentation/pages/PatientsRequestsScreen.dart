import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../iam/services/auth_session.dart';
import '../bloc/PatientsBloc.dart';
import '../../data/models/NutritionistPatientModel.dart';

class PatientsRequestsScreen extends StatefulWidget {
  const PatientsRequestsScreen({Key? key}) : super(key: key);

  @override
  State<PatientsRequestsScreen> createState() => _PatientsRequestsScreenState();
}

class _PatientsRequestsScreenState extends State<PatientsRequestsScreen> {
  final PatientsBloc patientsBloc = PatientsBloc();

  @override
  void initState() {
    super.initState();

    () async {
      final userId = await AuthSession.getUserId();
      final nutritionistId = await AuthSession.getNutritionistId();
      patientsBloc.add(FetchPatientsEvent(nutritionistId!));
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Solicitudes Pendientes",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      body: BlocBuilder<PatientsBloc, PatientsState>(
        bloc: patientsBloc,
        builder: (context, state) {
          if (state is PatientsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PatientsErrorState) {
            return Center(child: Text(state.message));
          }

          if (state is PatientsLoadedState) {
            final pendingPatients = state.patients
                .where((p) => p.accepted == false)
                .toList();

            if (pendingPatients.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No tienes solicitudes pendientes",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "${pendingPatients.length} ${pendingPatients.length == 1 ? 'solicitud' : 'solicitudes'} nuevas",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: pendingPatients.length,
                    itemBuilder: (context, index) {
                      final p = pendingPatients[index];
                      final profile = p.profile;

                      return _RequestCard(
                        name: "Paciente ${p.patientUserId}",
                        tipo_servicio: p.serviceType,
                        onTapAccept: () async {
                          final nutritionistId =
                          await AuthSession.getNutritionistId();

                          patientsBloc.add(
                            ApprovePatientEvent(
                              p.id,
                              nutritionistId!,
                            ),
                          );
                        },
                        onTapReject: () async {
                          final nutritionistId =
                          await AuthSession.getNutritionistId();

                          patientsBloc.add(
                            DeletePatientEvent(
                              p.id,
                              nutritionistId!,
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
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final String name;
  final String tipo_servicio;
  final Future<void> Function() onTapAccept;
  final Future<void> Function() onTapReject;

  const _RequestCard({
    super.key,
    required this.name,
    required this.tipo_servicio,
    required this.onTapAccept,
    required this.onTapReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person_add_outlined,
                  color: Colors.orange[700],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black87,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tipo_servicio,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    onTapAccept();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[100],
                    foregroundColor: Colors.green[800],
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text(
                    "Aceptar",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    onTapReject();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[100],
                    foregroundColor: Colors.red[800],
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text(
                    "Rechazar",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}