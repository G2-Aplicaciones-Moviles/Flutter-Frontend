import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category_model.dart';
import '../models/recipe_type_model.dart';
import '../../../iam/services/auth_session.dart';

class RecipeMetadataRepository {
  static const baseUrl = "http://10.0.2.2:8080/api/v1";

  Future<List<CategoryModel>> getCategories() async {
    final token = await AuthSession.getToken();
    final res = await http.get(
      Uri.parse("$baseUrl/categories"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    }

    return [];
  }

  Future<List<RecipeTypeModel>> getRecipeTypes() async {
    final token = await AuthSession.getToken();
    final res = await http.get(
      Uri.parse("$baseUrl/recipetypes"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);
      return data.map((e) => RecipeTypeModel.fromJson(e)).toList();
    }

    return [];
  }
}
