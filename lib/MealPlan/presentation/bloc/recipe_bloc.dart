import 'package:bloc/bloc.dart';

import '../../data/repositories/recipe_repository.dart';
import '../../data/models/add_recipe_request.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository repo = RecipeRepository();

  RecipeBloc() : super(RecipeInitial()) {
    on<LoadRecipesEvent>(_onLoadRecipes);
    on<AddRecipeToMealPlanEvent>(_onAddRecipeToMealPlan);
  }

  Future<void> _onLoadRecipes(
      LoadRecipesEvent event,
      Emitter<RecipeState> emit,
      ) async {
    emit(RecipeLoading());

    try {
      final recipes = await repo.getAllRecipes();
      emit(RecipesLoaded(recipes));
    } catch (e) {
      emit(RecipeError("Error al cargar recetas: $e"));
    }
  }

  Future<void> _onAddRecipeToMealPlan(
      AddRecipeToMealPlanEvent event,
      Emitter<RecipeState> emit,
      ) async {
    emit(RecipeLoading());

    try {
      final request = AddRecipeToMealPlanRequest(
        recipeId: event.recipeId,
        type: event.type,
        day: 1,
        userId: event.userId,
      );

      final success = await repo.addRecipeToMealPlan(
        event.mealPlanId,
        request,
      );

      if (!success) {
        emit(RecipeError("No se pudo agregar la receta al plan"));
        return;
      }

      emit(RecipeAddedToMealPlan());
    } catch (e) {
      emit(RecipeError("Error al agregar receta: $e"));
    }
  }
}