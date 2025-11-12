import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/primary_button.dart';
import 'add_recipe_screen.dart';

class CreatePlanScreen extends StatefulWidget {
  const CreatePlanScreen({super.key});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  String? selectedCategory;
  String? selectedTag;

  final List<String> categories = [
    'Alto en proteínas',
    'Bajo en carbohidratos',
    'Vegetariano',
    'Keto',
  ];

  final List<String> tags = [
    'Definición',
    'Mantenimiento',
    'Volumen',
    'Proteínas',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Creación de Plan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: .5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Imagen del menú
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.restaurant_menu,
                        size: 64, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo nombre
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Nombre',
                      style:
                      TextStyle(color: Colors.grey.shade800, fontSize: 14)),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    hintText: 'Menú Proteico',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),

                // Descripción
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Descripción',
                      style:
                      TextStyle(color: Colors.grey.shade800, fontSize: 14)),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText:
                    'Alto en proteínas, para etapa de definición o mantenimiento.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),

                // Categoría
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Categoría',
                      style:
                      TextStyle(color: Colors.grey.shade800, fontSize: 14)),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: categories
                      .map((c) =>
                      DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedCategory = val),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),

                // Tag
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Tag',
                      style:
                      TextStyle(color: Colors.grey.shade800, fontSize: 14)),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: selectedTag,
                  items: tags
                      .map((c) =>
                      DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedTag = val),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 20),

                // Botón agregar recetas
                PrimaryButton(
                  text: 'Agregar Recetas',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddRecipeScreen(
                          planName: nameCtrl.text.isEmpty
                              ? 'Nuevo Plan'
                              : nameCtrl.text,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
