import 'ingredient_model.dart';

class RecipeIngredientModel {
  final IngredientModel ingredient;
  final double amountGrams;

  RecipeIngredientModel({
    required this.ingredient,
    required this.amountGrams,
  });

  factory RecipeIngredientModel.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientModel(
      ingredient: IngredientModel.fromJson(json["ingredient"]),
      amountGrams: json["amountGrams"].toDouble(),
    );
  }
}
