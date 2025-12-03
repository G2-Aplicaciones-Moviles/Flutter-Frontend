import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/recipe_model.dart';
import '../../data/repositories/recipe_repository.dart';
import '../bloc/meal_plan_bloc.dart';
import '../bloc/meal_plan_event.dart';
import '../bloc/meal_plan_state.dart';
import '../../data/models/meal_plan_model.dart';

class MealPlanDetailPage extends StatefulWidget {
  final MealPlanModel mealPlan;

  const MealPlanDetailPage({super.key, required this.mealPlan});

  @override
  State<MealPlanDetailPage> createState() => _MealPlanDetailPageState();
}

class _MealPlanDetailPageState extends State<MealPlanDetailPage> {
  late MealPlanModel currentMealPlan;

  @override
  void initState() {
    super.initState();
    currentMealPlan = widget.mealPlan;
  }

  Future<void> _loadRecipesForMapping() async {
    final repo = RecipeRepository();
    final allRecipes = await repo.getAllRecipes();

    setState(() {
      currentMealPlan = currentMealPlan.copyWith(
        availableRecipes: allRecipes,
      );
    });
  }


  void _reloadMealPlan(BuildContext context) {
    context.read<MealPlanBloc>().add(
      GetMealPlanByIdEvent(
        currentMealPlan.id,
        currentMealPlan.profileId ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MealPlanBloc()
        ..add(
          GetMealPlanByIdEvent(
            widget.mealPlan.id,
            widget.mealPlan.profileId ?? 0,
          ),
        ),

      child: BlocListener<MealPlanBloc, MealPlanState>(
        listener: (context, state) async {
          if (state is MealPlanLoaded) {
            currentMealPlan = state.mealPlan;

            await _loadRecipesForMapping();

            setState(() {});
          }
        },

        child: Scaffold(
          appBar: AppBar(
            title: const Text("Detalle del Plan"),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, true),
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                const SizedBox(height: 24),

                _buildNutritionInfo(),
                const SizedBox(height: 24),

                _buildCategory(),
                const SizedBox(height: 24),

                _buildTags(),
                const SizedBox(height: 24),

                _buildRecipesHeader(),
                const SizedBox(height: 12),

                _buildEntriesList(currentMealPlan.entries),
                const SizedBox(height: 32),

                _buildAddButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Center(
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(16)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu,
                    size: 50, color: Colors.white),
                SizedBox(height: 12),
                Text("MENÚ",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          currentMealPlan.name,
          style:
          const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text("Descripción",
            style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          currentMealPlan.description,
          style:
          TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildNutritionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Información Nutricional",
            style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildNutritionCard(
                "Calorías",
                currentMealPlan.calories.toStringAsFixed(1),
                Icons.local_fire_department,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNutritionCard(
                "Carbos",
                "${currentMealPlan.carbs.toStringAsFixed(1)}g",
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
                "${currentMealPlan.proteins.toStringAsFixed(1)}g",
                Icons.fitness_center,
                Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNutritionCard(
                "Grasas",
                "${currentMealPlan.fats.toStringAsFixed(1)}g",
                Icons.water_drop,
                Colors.yellow[700]!,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Categoría",
            style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Chip(
          label: Text(currentMealPlan.category),
          backgroundColor: Colors.blue[100],
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Etiquetas",
            style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: currentMealPlan.tags
              .map((tag) => Chip(
            label: Text(tag),
            backgroundColor: Colors.green[100],
          ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRecipesHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Recetas",
            style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          "${currentMealPlan.entries.length} recetas en este plan",
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildEntriesList(List entries) {
    if (entries.isEmpty) {
      return const Text(
        "Aún no hay recetas en este plan.",
        style: TextStyle(fontSize: 14),
      );
    }

    return Column(
      children: entries.map((entry) {
        final map = entry as Map<String, dynamic>;
        final recipeId = map["recipeId"];
        final type = _mealTypeName(map["mealPlanType"]);
        final day = map["day"];

        return FutureBuilder<RecipeModel?>(
          future: RecipeRepository().getRecipeById(recipeId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Card(
                child: ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text("Cargando receta..."),
                ),
              );
            }

            final recipe = snapshot.data!;
            final recipeName = recipe.name;

            return Card(
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.restaurant, color: Colors.white),
                ),
                title: Text(
                  recipeName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Día $day • $type"),
              ),
            );
          },
        );
      }).toList(),
    );
  }


  String _mealTypeName(int type) {
    switch (type) {
      case 1:
        return "Desayuno";
      case 2:
        return "Almuerzo";
      case 3:
        return "Cena";
      case 4:
        return "Snack";
      default:
        return "Sin tipo";
    }
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final userId = currentMealPlan.profileId ?? 0;

          final added = await Navigator.pushNamed(
            context,
            "/add-recipes-to-meal-plan",
            arguments: {
              "mealPlan": currentMealPlan,
              "userId": userId,
            },
          );

          if (added == true) {
            _reloadMealPlan(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Agregar recetas",
          style:
          TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildNutritionCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700])),
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
