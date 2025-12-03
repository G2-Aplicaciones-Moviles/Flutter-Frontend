import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/meal_plan_model.dart';
import '../models/create_meal_plan_request.dart';
import '../../../iam/services/auth_session.dart';

class MealPlanRepository {
  static const String baseUrl = "http://10.0.2.2:5000/api/v1/meal-plan";

  Future<MealPlanModel?> createMealPlanTemplate(
    int nutritionistUserId,
    CreateMealPlanRequest request,
  ) async {
    final url = Uri.parse("$baseUrl/nutritionists/$nutritionistUserId");
    final token = await AuthSession.getToken();

    final res = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(request.toJson()),
    );

    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return MealPlanModel.fromJson(data);
    }

    return null;
  }

  Future<List<MealPlanModel>> getMealPlansByNutritionist(
    int nutritionistUserId,
  ) async {
    final url = Uri.parse("$baseUrl/nutritionists/$nutritionistUserId");
    final token = await AuthSession.getToken();

    final res = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((json) => MealPlanModel.fromJson(json)).toList();
    }

    return [];
  }

  Future<bool> deleteMealPlan(int mealPlanId) async {
    final url = Uri.parse("$baseUrl/$mealPlanId");
    final token = await AuthSession.getToken();

    final res = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204;
  }

  Future<MealPlanModel?> getMealPlanById(int id) async {
    final url = Uri.parse("$baseUrl/$id");
    final token = await AuthSession.getToken();

    final res = await http.get(url, headers: {
      "Authorization": "Bearer $token",
    });

    if (res.statusCode == 200) {
      return MealPlanModel.fromJson(jsonDecode(res.body));
    }

    return null;
  }


}
