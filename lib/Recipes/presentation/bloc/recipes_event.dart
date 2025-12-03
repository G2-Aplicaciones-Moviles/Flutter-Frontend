part of 'recipes_bloc.dart';

abstract class RecipesEvent {}

class CreateTemplateEvent extends RecipesEvent {
  final int nutritionistId;
  final RecipeRequest request;

  CreateTemplateEvent(this.nutritionistId, this.request);
}

class LoadTemplatesByNutritionistEvent extends RecipesEvent {
  final int nutritionistId;

  LoadTemplatesByNutritionistEvent(this.nutritionistId);
}

class LoadRecipeByIdEvent extends RecipesEvent {
  final int recipeId;

  LoadRecipeByIdEvent(this.recipeId);
}
