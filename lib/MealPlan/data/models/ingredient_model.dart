class IngredientModel {
  final int id;
  final String name;
  final double calories;
  final double proteins;
  final double fats;
  final double carbohydrates;
  final int macronutrientValuesId;

  IngredientModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.proteins,
    required this.fats,
    required this.carbohydrates,
    required this.macronutrientValuesId,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json["id"],
      name: json["name"],
      calories: json["calories"],
      proteins: json["proteins"],
      fats: json["fats"],
      carbohydrates: json["carbohydrates"],
      macronutrientValuesId: json["macronutrientValuesId"],
    );
  }
}
