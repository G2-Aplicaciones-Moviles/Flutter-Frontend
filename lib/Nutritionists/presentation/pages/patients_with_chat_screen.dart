import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/patients_cubit.dart';

class PatientsWithChatScreen extends StatefulWidget {
  final int nutritionistId;

  const PatientsWithChatScreen({super.key, required this.nutritionistId});

  @override
  State<PatientsWithChatScreen> createState() => _PatientsWithChatScreenState();
}

class _PatientsWithChatScreenState extends State<PatientsWithChatScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PatientsCubit>().loadPatients(widget.nutritionistId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Pacientes"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocConsumer<PatientsCubit, PatientsState>(
        listener: (context, state) {
          if (state is PatientsValidationSuccess) {
            // Navigate to chat screen
            Navigator.pushNamed(
              context,
              '/chat',
              arguments: {
                'nutritionistId': widget.nutritionistId,
                'patientId': state.patientId,
              },
            ).then((_) {
              // Refresh patients list when returning from chat
              context.read<PatientsCubit>().loadPatients(widget.nutritionistId);
            });
          } else if (state is PatientsValidationFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.orange,
              ),
            );
            // Reload patients after error
            context.read<PatientsCubit>().loadPatients(widget.nutritionistId);
          } else if (state is PatientsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PatientsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PatientsValidating) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Validando acceso al chat..."),
                ],
              ),
            );
          }

          if (state is PatientsLoaded) {
            if (state.patients.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people_outline, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      "No tienes pacientes aceptados",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        context
                            .read<PatientsCubit>()
                            .refresh(widget.nutritionistId);
                      },
                      child: const Text("Actualizar"),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<PatientsCubit>().refresh(widget.nutritionistId),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.patients.length,
                itemBuilder: (context, index) {
                  final patient = state.patients[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blue.shade100,
                        backgroundImage: patient.avatarUrl != null
                            ? NetworkImage(patient.avatarUrl!)
                            : null,
                        child: patient.avatarUrl == null
                            ? Text(
                          patient.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                            : null,
                      ),
                      title: Text(
                        patient.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (patient.email != null)
                            Text(
                              patient.email!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          if (patient.lastMessage != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              patient.lastMessage!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                          if (patient.lastMessageAt != null)
                            Text(
                              _formatDateTime(patient.lastMessageAt!),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.blue,
                      ),
                      onTap: () {
                        context.read<PatientsCubit>().validateAndNavigate(
                          widget.nutritionistId,
                          patient.userId,
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }

          return const Center(child: Text("Cargando..."));
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return "Ahora";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m";
    } else if (difference.inDays < 1) {
      return "${difference.inHours}h";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d";
    } else {
      return DateFormat('dd/MM/yy').format(dateTime);
    }
  }
}

