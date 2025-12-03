import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/pending_requests_cubit.dart';

class PendingRequestsScreen extends StatefulWidget {
  final int nutritionistId;

  const PendingRequestsScreen({super.key, required this.nutritionistId});

  @override
  State<PendingRequestsScreen> createState() => _PendingRequestsScreenState();
}

class _PendingRequestsScreenState extends State<PendingRequestsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PendingRequestsCubit>().loadRequests(widget.nutritionistId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solicitudes Pendientes"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocConsumer<PendingRequestsCubit, PendingRequestsState>(
        listener: (context, state) {
          if (state is PendingRequestsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PendingRequestsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PendingRequestsLoaded) {
            if (state.requests.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No hay solicitudes pendientes",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context
                  .read<PendingRequestsCubit>()
                  .refresh(widget.nutritionistId),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.requests.length,
                itemBuilder: (context, index) {
                  final request = state.requests[index];
                  final isProcessing = context.watch<PendingRequestsCubit>().state
                      is PendingRequestsProcessing &&
                      (context.watch<PendingRequestsCubit>().state
                      as PendingRequestsProcessing)
                          .requestId ==
                          request.id;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue.shade100,
                                child: Text(
                                  request.patientName[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      request.patientName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (request.patientEmail != null)
                                      Text(
                                        request.patientEmail!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            Icons.medical_services_outlined,
                            "Servicio",
                            request.service,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.calendar_today_outlined,
                            "Fecha solicitada",
                            DateFormat('dd/MM/yyyy').format(request.requestedDate),
                          ),
                          if (request.proposedDate != null) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.event_outlined,
                              "Fecha propuesta",
                              DateFormat('dd/MM/yyyy')
                                  .format(request.proposedDate!),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: isProcessing
                                      ? null
                                      : () {
                                    context
                                        .read<PendingRequestsCubit>()
                                        .rejectRequest(
                                      request.id,
                                      widget.nutritionistId,
                                    );
                                  },
                                  icon: const Icon(Icons.close),
                                  label: const Text("Rechazar"),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: isProcessing
                                      ? null
                                      : () {
                                    context
                                        .read<PendingRequestsCubit>()
                                        .approveRequest(
                                      request.id,
                                      widget.nutritionistId,
                                    );
                                  },
                                  icon: isProcessing
                                      ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                      : const Icon(Icons.check),
                                  label: const Text("Aceptar"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

