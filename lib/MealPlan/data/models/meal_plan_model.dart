class MealPlanModel {
  final int id;
  final String name;
  final String description;
  final double calories;
  final double carbs;
  final double proteins;
  final double fats;
  final int? profileId;
  final String category;
  final bool isCurrent;

  /// entries devueltos por backend
  final List<dynamic> entries;

  /// recetas disponibles para mapear recipeId -> RecipeModel
  final List<dynamic> availableRecipes;

  final List<String> tags;

  MealPlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.calories,
    required this.carbs,
    required this.proteins,
    required this.fats,
    this.profileId,
    required this.category,
    required this.isCurrent,
    required this.entries,
    required this.tags,
    required this.availableRecipes,
  });

  factory MealPlanModel.fromJson(Map<String, dynamic> json) {
    return MealPlanModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      calories: (json["calories"] as num).toDouble(),
      carbs: (json["carbs"] as num).toDouble(),
      proteins: (json["proteins"] as num).toDouble(),
      fats: (json["fats"] as num).toDouble(),
      profileId: json["profileId"],
      category: json["category"],
      isCurrent: json["isCurrent"],

      entries: json["entries"] ?? [],

      tags: List<String>.from(json["tags"] ?? []),

      /// IMPORTANTE: aún no cargamos recetas; se seteará luego
      availableRecipes: [],
    );
  }

  MealPlanModel copyWith({
    List<dynamic>? availableRecipes,
    List<dynamic>? entries,
  }) {
    return MealPlanModel(
      id: id,
      name: name,
      description: description,
      calories: calories,
      carbs: carbs,
      proteins: proteins,
      fats: fats,
      profileId: profileId,
      category: category,
      isCurrent: isCurrent,
      entries: entries ?? this.entries,
      tags: tags,
      availableRecipes: availableRecipes ?? this.availableRecipes,
    );
  }
}
