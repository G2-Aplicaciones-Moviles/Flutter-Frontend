import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/nutritionist_bloc.dart';
import '../bloc/nutritionist_event.dart';
import '../bloc/nutritionist_state.dart';

class CreateNutritionistProfilePage extends StatefulWidget {
  final int userId;

  const CreateNutritionistProfilePage({super.key, required this.userId});

  @override
  State<CreateNutritionistProfilePage> createState() =>
      _CreateNutritionistProfilePageState();
}

class _CreateNutritionistProfilePageState
    extends State<CreateNutritionistProfilePage> {
  final fullNameCtrl = TextEditingController();
  final licenseCtrl = TextEditingController();
  final specialtyCtrl = TextEditingController();
  final bioCtrl = TextEditingController();
  final yearsCtrl = TextEditingController();

  bool acceptingNewPatients = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bienvenido a JameoFit"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<NutritionistBloc, NutritionistState>(
          listener: (context, state) {
            if (state is NutritionistCreated) {
              // ✅ IMPORTANTE: pasar el userId al Home
              Navigator.pushReplacementNamed(
                context,
                "/home",
                arguments: widget.userId,
              );
            }

            if (state is NutritionistError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final loading = state is NutritionistLoading;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Completar Perfil",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  _field("Nombre completo", fullNameCtrl, Icons.person),
                  const SizedBox(height: 14),

                  _field("Número de colegiatura", licenseCtrl, Icons.badge),
                  const SizedBox(height: 14),

                  _field("Especialidad (ej. CLINICAL)", specialtyCtrl, Icons.star),
                  const SizedBox(height: 14),

                  _field("Años de experiencia", yearsCtrl, Icons.calendar_today,
                      type: TextInputType.number),
                  const SizedBox(height: 14),

                  _field("Biografía", bioCtrl, Icons.info, maxLines: 3),
                  const SizedBox(height: 14),

                  CheckboxListTile(
                    title: const Text("¿Acepta nuevos pacientes?"),
                    value: acceptingNewPatients,
                    onChanged: (v) {
                      setState(() => acceptingNewPatients = v!);
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () {
                        context.read<NutritionistBloc>().add(
                          CreateNutritionistEvent(
                            userId: widget.userId,
                            fullName: fullNameCtrl.text.trim(),
                            licenseNumber: licenseCtrl.text.trim(),
                            specialty: specialtyCtrl.text.trim(),
                            yearsExperience:
                            int.tryParse(yearsCtrl.text) ?? 0,
                            bio: bioCtrl.text.trim(),
                            acceptingNewPatients:
                            acceptingNewPatients,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Text(
                        loading ? "Guardando..." : "Guardar Perfil",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon,
      {int maxLines = 1, TextInputType type = TextInputType.text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(width: 1.2, color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: type,
        decoration: InputDecoration(
          icon: Icon(icon),
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
