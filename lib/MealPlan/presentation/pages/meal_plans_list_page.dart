import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/meal_plan_bloc.dart';
import '../bloc/meal_plan_event.dart';
import '../bloc/meal_plan_state.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';

class MealPlansListPage extends StatelessWidget {
  final int userId;

  const MealPlansListPage({super.key, required this.userId});

  void _showDeleteConfirmation(
      BuildContext context,
      int mealPlanId,
      String mealPlanName,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Eliminar Plan"),
        content: Text("¿Estás seguro de eliminar '$mealPlanName'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<MealPlanBloc>().add(DeleteMealPlanEvent(
                mealPlanId,
                userId,
              ));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MealPlanBloc>(
          create: (_) => MealPlanBloc()..add(LoadMealPlansEvent(userId)),
        ),
        BlocProvider<RecipeBloc>(create: (_) => RecipeBloc()),
      ],
      child: BlocListener<RecipeBloc, RecipeState>(
        listener: (context, state) {
          if (state is RecipeAddedToMealPlan) {
            context.read<MealPlanBloc>().add(LoadMealPlansEvent(userId));
          }
        },
        child: BlocConsumer<MealPlanBloc, MealPlanState>(
          listener: (context, state) {
            if (state is MealPlanError &&
                state.message != "Eliminado correctamente") {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is MealPlanLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MealPlansLoaded) {
              final plans = state.mealPlans;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Planes Alimenticios creados por ti",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Lista de planes",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: plans.isEmpty
                        ? const Center(child: Text("No hay planes creados"))
                        : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: plans.length,
                      itemBuilder: (_, index) {
                        final plan = plans[index];

                        return GestureDetector(
                          onTap: () async {
                            final updated = await Navigator.pushNamed(
                              context,
                              "/meal-plan-detail",
                              arguments: plan,
                            );

                            if (updated == true && context.mounted) {
                              context
                                  .read<MealPlanBloc>()
                                  .add(LoadMealPlansEvent(userId));
                            }
                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 120,
                                  decoration: const BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.restaurant_menu,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "MENÚ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plan.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${plan.entries.length} recetas",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Colors.grey[600],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _showDeleteConfirmation(
                                                context,
                                                plan.id,
                                                plan.name,
                                              );
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Botón crear nuevo plan
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final created = await Navigator.pushNamed(
                            context,
                            "/create-meal-plan",
                            arguments: userId,
                          );

                          if (created == true && context.mounted) {
                            context
                                .read<MealPlanBloc>()
                                .add(LoadMealPlansEvent(userId));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Crear Nuevo Plan Alimenticio",
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
