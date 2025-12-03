import 'recipe_ingredient_model.dart';

class RecipeModel {
  final int id;
  final int? createdByNutritionistId;
  final int? assignedToProfileId;
  final String name;
  final String description;
  final int preparationTime;
  final String difficulty;
  final String category;
  final String recipeType;
  final List<RecipeIngredientModel> ingredients;

  RecipeModel({
    required this.id,
    required this.createdByNutritionistId,
    required this.assignedToProfileId,
    required this.name,
    required this.description,
    required this.preparationTime,
    required this.difficulty,
    required this.category,
    required this.recipeType,
    required this.ingredients,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    final ingr = (json["ingredients"] as List?) ?? [];

    return RecipeModel(
      id: json["id"],
      createdByNutritionistId: json["createdByNutritionistId"],
      assignedToProfileId: json["assignedToProfileId"],
      name: json["name"],
      description: json["description"],
      preparationTime: json["preparationTime"],
      difficulty: json["difficulty"],
      category: json["categoryName"],
      recipeType: json["recipeTypeName"],
      ingredients: ingr.map((e) => RecipeIngredientModel.fromJson(e)).toList(),
    );
  }
}
