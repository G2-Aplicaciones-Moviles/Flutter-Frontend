class RecipeRequest {
  final String name;
  final String description;
  final int preparationTime;
  final String difficulty;
  final int categoryId;
  final int recipeTypeId;

  RecipeRequest({
    required this.name,
    required this.description,
    required this.preparationTime,
    required this.difficulty,
    required this.categoryId,
    required this.recipeTypeId,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "preparationTime": preparationTime,
    "difficulty": difficulty,
    "categoryId": categoryId,
    "recipeTypeId": recipeTypeId,
  };
}
