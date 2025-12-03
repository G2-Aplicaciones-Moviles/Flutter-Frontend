import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';
import '../../data/models/meal_plan_model.dart';

class AddRecipesToMealPlanPage extends StatefulWidget {
  final MealPlanModel mealPlan;
  final int userId;

  const AddRecipesToMealPlanPage({
    super.key,
    required this.mealPlan,
    required this.userId,
  });

  @override
  State<AddRecipesToMealPlanPage> createState() =>
      _AddRecipesToMealPlanPageState();
}

class _AddRecipesToMealPlanPageState extends State<AddRecipesToMealPlanPage> {
  String? selectedMealType;
  String searchQuery = '';

  final List<Map<String, String>> mealTypes = [
    {"value": "Breakfast", "label": "Desayuno"},
    {"value": "Lunch", "label": "Almuerzo"},
    {"value": "Dinner", "label": "Cena"},
    {"value": "Snack", "label": "Snack"},
  ];

  void _showAddRecipeDialog(
      BuildContext context, int recipeId, String recipeName) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Agregar Receta"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("¿Agregar '$recipeName' al plan?"),
            const SizedBox(height: 16),
            const Text(
              "Tipo de comida:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedMealType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              hint: const Text("Selecciona un tipo"),
              items: mealTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type["value"],
                  child: Text(type["label"]!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMealType = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              if (selectedMealType != null) {
                Navigator.pop(dialogContext);
                context.read<RecipeBloc>().add(
                  AddRecipeToMealPlanEvent(
                    mealPlanId: widget.mealPlan.id,
                    recipeId: recipeId,
                    type: selectedMealType!,
                    userId: widget.userId,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Por favor selecciona un tipo de comida"),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text("Agregar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecipeBloc()..add(LoadRecipesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Agregar Recetas"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: BlocConsumer<RecipeBloc, RecipeState>(
          listener: (context, state) {
            if (state is RecipeAddedToMealPlan) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Receta agregada exitosamente"),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<RecipeBloc>().add(LoadRecipesEvent());
            }

            if (state is RecipeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is RecipeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is RecipesLoaded) {
              var recipes = state.recipes;

              // Filtrado solo por nombre
              if (searchQuery.isNotEmpty) {
                recipes = recipes
                    .where(
                      (r) => r.name
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()),
                )
                    .toList();
              }

              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[100],
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.restaurant_menu,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.mealPlan.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "${widget.mealPlan.entries.length} recetas agregadas",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),

                  // Buscador por nombre
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Buscar receta",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),

                  // Listado de recetas filtradas
                  Expanded(
                    child: recipes.isEmpty
                        ? const Center(child: Text("No hay recetas disponibles"))
                        : ListView.builder(
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = recipes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            title: Text(recipe.name),
                            subtitle: Text(recipe.recipeType ?? ""),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                _showAddRecipeDialog(
                                  context,
                                  recipe.id,
                                  recipe.name,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Botón finalizar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            "/meal-plans-list",
                            arguments: widget.userId,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Finalizar y ver mis planes",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return const Center(child: Text("Estado desconocido"));
          },
        ),
      ),
    );
  }
}
