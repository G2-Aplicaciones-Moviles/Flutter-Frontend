import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/nutritionist_repository.dart';

class NutritionistProfileEditPage extends StatefulWidget {
  final Map<String, dynamic> data; // Perfil actual del backend
  final int userId;

  const NutritionistProfileEditPage({
    super.key,
    required this.data,
    required this.userId,
  });

  @override
  State<NutritionistProfileEditPage> createState() =>
      _NutritionistProfileEditPageState();
}

class _NutritionistProfileEditPageState
    extends State<NutritionistProfileEditPage> {
  final picker = ImagePicker();
  String? newProfileImage;

  late TextEditingController fullNameCtrl;
  late TextEditingController licenseCtrl;
  late TextEditingController specialtyCtrl;
  late TextEditingController bioCtrl;
  late TextEditingController yearsCtrl;

  bool acceptingNewPatients = true;

  @override
  void initState() {
    super.initState();

    fullNameCtrl = TextEditingController(text: widget.data["fullName"] ?? "");
    licenseCtrl = TextEditingController(text: widget.data["licenseNumber"] ?? "");
    specialtyCtrl = TextEditingController(text: widget.data["specialty"] ?? "");
    bioCtrl = TextEditingController(text: widget.data["bio"] ?? "");
    yearsCtrl = TextEditingController(
        text: widget.data["yearsExperience"]?.toString() ?? "0");

    acceptingNewPatients = widget.data["acceptingNewPatients"] ?? true;
  }

  Future<void> _pickImage() async {
    try {
      final file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null) return;

      setState(() => newProfileImage = file.path);

    } catch (e) {
      print("ERROR PICKING IMAGE: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = NutritionistRepository();
    final nutritionistId = widget.data["id"]; // 🔥 MUY IMPORTANTE

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // =========================
            // FOTO DE PERFIL
            // =========================
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: newProfileImage != null
                        ? FileImage(
                      // ignore: unnecessary_non_null_assertion
                      File(newProfileImage!),
                    )
                        : (widget.data["profilePictureUrl"] == null ||
                        widget.data["profilePictureUrl"] == "")
                        ? null
                        : NetworkImage(widget.data["profilePictureUrl"])
                    as ImageProvider,
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.camera_alt,
                            size: 20, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // CAMPOS
            _field("Nombre completo", fullNameCtrl),
            _field("Número de colegiatura", licenseCtrl),
            _field("Especialidad", specialtyCtrl),
            _field("Biografía", bioCtrl, max: 3),
            _field("Años de experiencia", yearsCtrl,
                type: TextInputType.number),

            CheckboxListTile(
              title: const Text("¿Acepta nuevos pacientes?"),
              value: acceptingNewPatients,
              onChanged: (v) => setState(() => acceptingNewPatients = v!),
            ),

            const SizedBox(height: 25),

            // =========================
            // BOTÓN GUARDAR
            // =========================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // 🔥 ARMAR JSON PARA UPDATE
                  final updatedData = {
                    "fullName": fullNameCtrl.text.trim(),
                    "licenseNumber": licenseCtrl.text.trim(),
                    "specialty": specialtyCtrl.text.trim(),
                    "yearsExperience":
                    int.tryParse(yearsCtrl.text.trim()) ?? 0,
                    "bio": bioCtrl.text.trim(),
                    "acceptingNewPatients": acceptingNewPatients,
                    "profilePictureUrl": widget.data["profilePictureUrl"],
                  };

                  final ok =
                  await repo.updateNutritionist(nutritionistId, updatedData);

                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Error al guardar cambios"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Guardar Cambios",
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
      String label,
      TextEditingController ctrl, {
        int max = 1,
        TextInputType type = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        maxLines: max,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
