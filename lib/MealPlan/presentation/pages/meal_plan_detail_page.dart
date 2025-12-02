import 'package:flutter/material.dart';
import '../../data/models/meal_plan_model.dart';

class MealPlanDetailPage extends StatelessWidget {
  final MealPlanModel mealPlan;

  const MealPlanDetailPage({super.key, required this.mealPlan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle del Plan"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono del plan
            Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restaurant_menu, size: 50, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      "MENÚ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Nombre del plan
            Text(
              mealPlan.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Descripción
            const Text(
              "Descripción",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mealPlan.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 24),

            // Información nutricional
            const Text(
              "Información Nutricional",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildNutritionCard(
                    "Calorías",
                    "${mealPlan.calories.toStringAsFixed(1)}",
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNutritionCard(
                    "Carbos",
                    "${mealPlan.carbs.toStringAsFixed(1)}g",
                    Icons.grain,
                    Colors.brown,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildNutritionCard(
                    "Proteínas",
                    "${mealPlan.proteins.toStringAsFixed(1)}g",
                    Icons.fitness_center,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNutritionCard(
                    "Grasas",
                    "${mealPlan.fats.toStringAsFixed(1)}g",
                    Icons.water_drop,
                    Colors.yellow[700]!,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Categoría
            const Text(
              "Categoría",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(mealPlan.category),
              backgroundColor: Colors.blue[100],
            ),

            const SizedBox(height: 24),

            // Tags
            const Text(
              "Etiquetas",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: mealPlan.tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: Colors.green[100],
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Recetas
            const Text(
              "Recetas",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${mealPlan.entries.length} recetas en este plan",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 24),

            // Estado
            Row(
              children: [
                Icon(
                  mealPlan.isCurrent ? Icons.check_circle : Icons.cancel,
                  color: mealPlan.isCurrent ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  mealPlan.isCurrent ? "Plan Activo" : "Plan Inactivo",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: mealPlan.isCurrent ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
