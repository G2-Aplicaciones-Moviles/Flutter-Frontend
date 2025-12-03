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
      appBar: AppBar(title: const Text("Solicitudes pendientes")),
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
              return const Center(child: Text("No tienes solicitudes pendientes."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pendingPatients.length,
              itemBuilder: (context, index) {
                final p = pendingPatients[index];
                final profile = p.profile;

                return _RequestCard(
                  name: "Paciente ${p.patientUserId}",
                  tipo_servicio: "Servicio: ${p.serviceType}",
                  onTapAccept: () async {
                    final nutritionistId = await AuthSession.getNutritionistId();

                    patientsBloc.add(
                      ApprovePatientEvent(
                        p.id,
                        nutritionistId!,
                      ),
                    );
                  },
                  onTapReject: () async {
                    final nutritionistId = await AuthSession.getNutritionistId();

                    patientsBloc.add(
                      DeletePatientEvent(
                        p.id,
                        nutritionistId!,
                      ),
                    );
                  },
                );
              },
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
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          Text(tipo_servicio),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  onTapAccept();
                },
                child: const Text("Aceptar"),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {
                  onTapReject();
                },
                child: const Text("Rechazar"),
              )
            ],
          )
        ],
      ),
    );
  }
}
