import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../iam/services/auth_session.dart';

class IngredientsRepository {
  static const String baseUrl = "http://10.0.2.2:8080/api/v1/ingredients";
  static const String recipesUrl = "http://10.0.2.2:8080/api/v1/recipes";

  Future<List<dynamic>> getAllIngredients() async {
    final token = await AuthSession.getToken();

    final res = await http.get(
      Uri.parse(baseUrl),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode != 200) return [];

    return jsonDecode(res.body);
  }

  Future<bool> createIngredient(Map<String, dynamic> data) async {
    final token = await AuthSession.getToken();

    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    return res.statusCode == 201;
  }

  Future<bool> deleteIngredient(int id) async {
    final token = await AuthSession.getToken();

    final res = await http.delete(
      Uri.parse("$baseUrl/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    return res.statusCode == 204;
  }

  Future<bool> addIngredientToRecipe(
      int recipeId, int ingredientId, double grams) async {

    final token = await AuthSession.getToken();

    final body = {
      "ingredientId": ingredientId,
      "amountGrams": grams,
    };

    final res = await http.put(
      Uri.parse("$recipesUrl/$recipeId/add-ingredient"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    return res.statusCode == 200;
  }
}
