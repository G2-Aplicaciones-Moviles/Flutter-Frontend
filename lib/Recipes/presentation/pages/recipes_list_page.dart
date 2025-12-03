import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipes_bloc.dart';

class RecipesListPage extends StatelessWidget {
  final int nutritionistId;

  const RecipesListPage({super.key, required this.nutritionistId});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<RecipesBloc, RecipesState>(
          builder: (context, state) {
            if (state is RecipesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TemplatesLoaded) {
              final recipes = state.templates;

              if (recipes.isEmpty) {
                return const Center(
                  child: Text("No tienes recetas aún"),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.80,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: recipes.length,
                itemBuilder: (_, i) {
                  final r = recipes[i];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/recipes/detail',
                        arguments: r.id,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.yellow.shade700,
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/food.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            r.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${r.ingredients.length} ingredientes",
                            style: const TextStyle(fontSize: 13),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Icon(Icons.delete, size: 18),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),

        // ✔ FAB flotante manual (porque no hay Scaffold)
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton.extended(
            onPressed: () async {
              await Navigator.pushNamed(
                context,
                "/recipes/create",
                arguments: nutritionistId,
              );

              // Refrescar recetas luego de crear
              context
                  .read<RecipesBloc>()
                  .add(LoadTemplatesByNutritionistEvent(nutritionistId));
            },
            label: const Text("Agregar Receta"),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.blueAccent,
          ),
        )
      ],
    );
  }
}
