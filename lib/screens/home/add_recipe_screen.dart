import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/primary_button.dart';

class AddRecipeScreen extends StatelessWidget {
  final String planName;
  const AddRecipeScreen({super.key, required this.planName});

  @override
  Widget build(BuildContext context) {
    final recipes = [
      {'name': 'Arroz con pollo', 'p': 120, 'c': 140, 'g': 88, 'cal': 567},
      {'name': 'Estofado de carne', 'p': 118, 'c': 136, 'g': 90, 'cal': 582},
      {'name': 'Fideos rojos', 'p': 111, 'c': 160, 'g': 86, 'cal': 640},
      {'name': 'Bistec con arroz', 'p': 130, 'c': 140, 'g': 81, 'cal': 579},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Agregar Receta'),
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
                const SizedBox(height: 8),
                Text(planName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Recetas',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                const SizedBox(height: 8),

                // Lista de recetas
                Column(
                  children: recipes
                      .map(
                        (r) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.restaurant),
                        title: Text(r['name'] as String),
                        subtitle: Text(
                          'P: ${r['p']} | C: ${r['c']} | G: ${r['g']}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Calorías: ${r['cal']}',
                                style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(Icons.add,
                                    size: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),

                const SizedBox(height: 20),
                PrimaryButton(
                  text: 'Crear Nuevo Plan Alimenticio',
                  onPressed: () {
                    Navigator.popUntil(context, (r) => r.isFirst);
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
