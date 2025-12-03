import 'ingredient_model.dart';

class RecipeIngredientModel2 {
  final IngredientModel ingredient;
  final double amountGrams;

  RecipeIngredientModel2({
    required this.ingredient,
    required this.amountGrams,
  });

  factory RecipeIngredientModel2.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientModel2(
      ingredient: IngredientModel.fromJson(json["ingredient"]),
      amountGrams: json["amountGrams"].toDouble(),
    );
  }
}
