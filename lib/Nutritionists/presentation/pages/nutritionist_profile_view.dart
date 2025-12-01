import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Nutritionists/data/repositories/nutritionist_repository.dart';
import 'nutritionist_profile_edit_page.dart';

class NutritionistProfileView extends StatefulWidget {
  final int userId;

  const NutritionistProfileView({super.key, required this.userId});

  @override
  State<NutritionistProfileView> createState() =>
      _NutritionistProfileViewState();
}

class _NutritionistProfileViewState extends State<NutritionistProfileView> {
  late Future<Map<String, dynamic>?> nutritionistFuture;
  final repo = NutritionistRepository();

  @override
  void initState() {
    super.initState();
    nutritionistFuture = repo.getNutritionistByUserId(widget.userId);
  }

  void refreshProfile() {
    setState(() {
      nutritionistFuture = repo.getNutritionistByUserId(widget.userId);
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final file = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (file == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Imagen seleccionada: ${file.name}")),
    );
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: nutritionistFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data;
        if (data == null) {
          return const Center(child: Text("No se pudo cargar el perfil"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NutritionistProfileEditPage(
                          data: data,
                          userId: widget.userId,
                        ),
                      ),
                    );

                    if (updated == true) refreshProfile();
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Editar perfil"),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                      (data["profilePictureUrl"] == null ||
                          data["profilePictureUrl"] == "")
                          ? null
                          : NetworkImage(data["profilePictureUrl"]),
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

              Center(
                child: Column(
                  children: [
                    Text(
                      data["fullName"] ?? "Nombre no disponible",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data["specialty"] ?? "Especialidad no registrada",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text("Biografía",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(data["bio"] ?? "Sin biografía registrada"),
              ),

              const SizedBox(height: 30),

              const Text("Mis Servicios",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: const [
                            Text("S/ 50"),
                            SizedBox(height: 8),
                            Text("Consulta Personal"),
                            SizedBox(height: 8),
                            Text("1 hora"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: const [
                            Text("S/ 100"),
                            SizedBox(height: 8),
                            Text("Plan Nutricional"),
                            SizedBox(height: 8),
                            Text("30 días"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
