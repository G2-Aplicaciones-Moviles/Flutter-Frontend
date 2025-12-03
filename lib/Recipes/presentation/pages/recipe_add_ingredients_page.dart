import 'package:flutter/material.dart';
import '../../data/repositories/ingredients_repository.dart';

class AddIngredientsPage extends StatefulWidget {
  final int recipeId;

  const AddIngredientsPage({super.key, required this.recipeId});

  @override
  State<AddIngredientsPage> createState() => _AddIngredientsPageState();
}

class _AddIngredientsPageState extends State<AddIngredientsPage> {
  late Future<List<dynamic>> ingredients;

  @override
  void initState() {
    super.initState();
    ingredients = IngredientsRepository().getAllIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Ingredientes"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: FutureBuilder(
        future: ingredients,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final ingr = snap.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ingr.length,
            itemBuilder: (_, i) {
              final item = ingr[i];

              return Card(
                child: ListTile(
                  title: Text(item["name"]),
                  subtitle: Text("Calorías: ${item["calories"]}"),

                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                    onPressed: () async {
                      final ok = await IngredientsRepository().addIngredientToRecipe(
                        widget.recipeId,
                        item["id"],
                        100, // gramos por defecto
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(ok
                              ? "Ingrediente agregado"
                              : "Error al agregar"),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
