part of 'recipes_bloc.dart';

abstract class RecipesState {}

class RecipesInitial extends RecipesState {}

class RecipesLoading extends RecipesState {}

class RecipeCreated extends RecipesState {}

class TemplatesLoaded extends RecipesState {
  final List<RecipeModel> templates;
  TemplatesLoaded(this.templates);
}

class RecipeLoaded extends RecipesState {
  final RecipeModel recipe;
  RecipeLoaded(this.recipe);
}

class RecipesError extends RecipesState {
  final String message;
  RecipesError(this.message);
}
