import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../iam/services/auth_session.dart';
import '../models/recipe_request.dart';
import '../models/recipe_model.dart';

class RecipesRepository {
  static const String baseUrl = "http://10.0.2.2:5000/api/v1/recipes";

  Future<bool> createRecipeTemplate(int nutritionistId, RecipeRequest request) async {
    final token = await AuthSession.getToken();

    final res = await http.post(
      Uri.parse("$baseUrl/nutritionists/$nutritionistId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    return res.statusCode == 201;
  }

  Future<List<RecipeModel>> getTemplatesByNutritionist(int nutritionistId) async {
    final token = await AuthSession.getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/nutritionists/$nutritionistId/templates"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode != 200) return [];

    final List data = jsonDecode(res.body);
    return data.map((e) => RecipeModel.fromJson(e)).toList();
  }

  Future<RecipeModel?> getRecipeById(int id) async {
    final token = await AuthSession.getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode != 200) return null;

    return RecipeModel.fromJson(jsonDecode(res.body));
  }
}
