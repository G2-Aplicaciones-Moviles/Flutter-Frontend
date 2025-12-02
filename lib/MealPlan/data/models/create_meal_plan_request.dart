class CreateMealPlanRequest {
  final String name;
  final String description;
  final double calories;
  final double carbs;
  final double proteins;
  final double fats;
  final int? profileId;
  final String category;
  final bool isCurrent;
  final List<String> tags;

  CreateMealPlanRequest({
    required this.name,
    required this.description,
    required this.calories,
    required this.carbs,
    required this.proteins,
    required this.fats,
    this.profileId,
    required this.category,
    required this.isCurrent,
    required this.tags,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "calories": calories,
        "carbs": carbs,
        "proteins": proteins,
        "fats": fats,
        "profileId": profileId,
        "category": category,
        "isCurrent": isCurrent,
        "tags": tags,
      };
}

