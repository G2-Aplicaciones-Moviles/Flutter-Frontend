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
        title: const Text("Detalles de Receta"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen estilo mockup
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.yellow.shade700,
                      image: const DecorationImage(
                        image: AssetImage("assets/food.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Nombre de receta
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${recipe.category} • ${recipe.recipeType} • ${recipe.difficulty}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Ingredientes",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  if (recipe.ingredients.isEmpty)
                    const Text("Aún no hay ingredientes agregados."),

                  Column(
                    children: recipe.ingredients.map((ing) {
                      return Card(
                        child: ListTile(
                          title: Text(ing.ingredient.name),
                          subtitle: Text(
                            "${ing.amountGrams} g • ${ing.ingredient.calories} kcal",
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/recipes/add-ingredients",
                          arguments: recipeId,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Agregar Ingredientes",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text(
              "Error al cargar la receta",
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
