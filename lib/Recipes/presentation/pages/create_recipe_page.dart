import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipes_bloc.dart';
import '../../data/models/recipe_request.dart';

class CreateRecipePage extends StatefulWidget {
  final int nutritionistId;

  const CreateRecipePage({super.key, required this.nutritionistId});

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final prepCtrl = TextEditingController();

  String selectedDifficulty = "Fácil";
  int selectedCategory = 1;
  int selectedType = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Receta"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: BlocConsumer<RecipesBloc, RecipesState>(
        listener: (context, state) {
          if (state is RecipeCreated) {
            Navigator.pop(context);
          }
        },

        builder: (context, state) {
          final loading = state is RecipesLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Imagen
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.yellow.shade700,
                    image: const DecorationImage(
                      image: AssetImage("assets/food.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                _field("Nombre de la receta", nameCtrl),
                _field("Descripción", descCtrl, maxLines: 3),
                _field("Tiempo de preparación (min)", prepCtrl, type: TextInputType.number),

                const SizedBox(height: 12),

                _dropdown("Dificultad", ["Fácil", "Medio", "Difícil"], (v) {
                  selectedDifficulty = v!;
                  setState(() {});
                }),

                _dropdown("Categoría", ["1", "2", "3"], (v) {
                  selectedCategory = int.parse(v!);
                  setState(() {});
                }),

                _dropdown("Tipo de receta", ["1", "2"], (v) {
                  selectedType = int.parse(v!);
                  setState(() {});
                }),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: loading
                      ? null
                      : () {
                    final request = RecipeRequest(
                      name: nameCtrl.text,
                      description: descCtrl.text,
                      preparationTime: int.tryParse(prepCtrl.text) ?? 0,
                      difficulty: selectedDifficulty,
                      categoryId: selectedCategory,
                      recipeTypeId: selectedType,
                    );

                    context.read<RecipesBloc>().add(
                        CreateTemplateEvent(widget.nutritionistId, request));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(
                    loading ? "Guardando..." : "Crear Receta",
                    style: const TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {int maxLines = 1, TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _dropdown(String label, List<String> items, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
