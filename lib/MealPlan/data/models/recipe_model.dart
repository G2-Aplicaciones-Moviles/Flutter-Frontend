class RecipeModel {
  final int id;
  final int userId;
  final String name;
  final String description;
  final int preparationTime;
  final String difficulty;
  final String category;
  final String recipeType;
  final List<String> ingredients;

  RecipeModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.preparationTime,
    required this.difficulty,
    required this.category,
    required this.recipeType,
    required this.ingredients,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json["id"],
      userId: json["userId"],
      name: json["name"],
      description: json["description"],
      preparationTime: json["preparationTime"],
      difficulty: json["difficulty"],
      category: json["category"],
      recipeType: json["recipeType"],
      ingredients: List<String>.from(json["ingredients"] ?? []),
    );
  }
}

