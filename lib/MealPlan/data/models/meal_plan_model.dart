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
  final List<dynamic> entries;
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
    );
  }
}

