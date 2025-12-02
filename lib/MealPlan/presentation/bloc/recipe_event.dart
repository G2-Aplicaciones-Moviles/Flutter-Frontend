import '../../data/models/add_recipe_request.dart';

abstract class RecipeEvent {}

class LoadRecipesEvent extends RecipeEvent {}

class AddRecipeToMealPlanEvent extends RecipeEvent {
  final int mealPlanId;
  final int recipeId;
  final String type;
  final int userId;

  AddRecipeToMealPlanEvent({
    required this.mealPlanId,
    required this.recipeId,
    required this.type,
    required this.userId,
  });
}

