import '../../data/models/recipe_model.dart';

abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipesLoaded extends RecipeState {
  final List<RecipeModel> recipes;
  RecipesLoaded(this.recipes);
}

class RecipeAddedToMealPlan extends RecipeState {}

class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);
}

