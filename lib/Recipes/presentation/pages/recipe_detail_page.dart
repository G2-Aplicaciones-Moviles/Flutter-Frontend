import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipes_bloc.dart';

class RecipeDetailPage extends StatelessWidget {
  final int recipeId;

  const RecipeDetailPage({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de la Receta"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: BlocBuilder<RecipesBloc, RecipesState>(
        builder: (context, state) {
          if (state is RecipesInitial) {
            context.read<RecipesBloc>().add(LoadRecipeByIdEvent(recipeId));
          }

          if (state is RecipesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RecipeLoaded) {
            final recipe = state.recipe;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Stack(
                    children: [
                      Container(
                        height: 230,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade700,
                          image: const DecorationImage(
                            image: AssetImage("assets/images/food.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 8,
                                offset: const Offset(0, -3),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nombre
                              Text(
                                recipe.name,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Chips de categoría / tipo / dificultad
                              Wrap(
                                spacing: 8,
                                children: [
                                  Chip(
                                    label: Text(recipe.category),
                                    backgroundColor: Colors.blue.shade100,
                                    materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  Chip(
                                    label: Text(recipe.recipeType),
                                    backgroundColor: Colors.green.shade100,
                                  ),
                                  Chip(
                                    label: Text(recipe.difficulty),
                                    backgroundColor: Colors.red.shade100,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 🔥 Info rápida (tiempo / calorías)
                  _buildSectionTitle("Resumen"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _infoCard(
                            icon: Icons.timer,
                            label: "Tiempo",
                            value: "${recipe.preparationTime} min",
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _infoCard(
                            icon: Icons.local_fire_department,
                            label: "Calorías",
                            value: "${_sumCalories(recipe).toStringAsFixed(0)} kcal",
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // INGREDIENTES
                  _buildSectionTitle("Ingredientes"),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children: recipe.ingredients.map((ing) {
                        return Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.yellow.shade600,
                              child: const Icon(Icons.restaurant, color: Colors.white),
                            ),
                            title: Text(
                              ing.ingredient.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              "${ing.amountGrams} g • ${ing.ingredient.calories.toStringAsFixed(0)} kcal",
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            "/recipes/add-ingredients",
                            arguments: recipeId,
                          );

                          context.read<RecipesBloc>().add(
                            LoadRecipeByIdEvent(recipeId),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Agregar Ingredientes",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            );
          }

          return const Center(
            child: Text("Error al cargar la receta",
                style: TextStyle(color: Colors.red)),
          );
        },
      ),
    );
  }

  // 🔥 Widgets reutilizables
  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  double _sumCalories(recipe) {
    double total = 0;
    for (var ing in recipe.ingredients) {
      total += ing.ingredient.calories;
    }
    return total;
  }
}
