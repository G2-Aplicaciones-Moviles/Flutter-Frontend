import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/recipe_model.dart';
import '../models/add_recipe_request.dart';
import '../../../iam/services/auth_session.dart';

class RecipeRepository {
  static const String baseUrl = "http://10.0.2.2:5000/api/v1";

  Future<List<RecipeModel>> getAllRecipes() async {
    final url = Uri.parse("$baseUrl/recipes");
    final token = await AuthSession.getToken();

    final res = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((json) => RecipeModel.fromJson(json)).toList();
    }

    return [];
  }

  Future<bool> addRecipeToMealPlan(
    int mealPlanId,
    AddRecipeToMealPlanRequest request,
  ) async {
    final url = Uri.parse("$baseUrl/meal-plan/$mealPlanId/entries");
    final token = await AuthSession.getToken();

    final res = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(request.toJson()),
    );

    // Éxito si statusCode es 200 o 201
    return res.statusCode == 200 || res.statusCode == 201;
  }
}
