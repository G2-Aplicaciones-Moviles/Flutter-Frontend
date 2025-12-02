class AddRecipeToMealPlanRequest {
  final int recipeId;
  final String type;
  final int day;
  final int userId;

  AddRecipeToMealPlanRequest({
    required this.recipeId,
    required this.type,
    required this.day,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        "recipeId": recipeId,
        "type": type,
        "day": day,
        "userId": userId,
      };
}

