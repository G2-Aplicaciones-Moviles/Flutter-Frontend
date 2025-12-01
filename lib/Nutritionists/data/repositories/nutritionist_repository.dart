import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../iam/services/auth_session.dart';

class NutritionistRepository {
  static const String baseUrl = "http://10.0.2.2:5000/api/v1/nutritionists";

  Future<bool> nutritionistExists(int userId) async {
    final token = await AuthSession.getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/by-user?userId=$userId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    return res.statusCode == 200;
  }

  Future<bool> createNutritionist(Map<String, dynamic> data) async {
    final token = await AuthSession.getToken();

    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data),
    );

    return res.statusCode == 200;
  }

  Future<Map<String, dynamic>?> getNutritionistByUserId(int userId) async {
    final token = await AuthSession.getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/by-user?userId=$userId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (res.statusCode != 200) return null;

    return jsonDecode(res.body);
  }

  Future<bool> updateNutritionist(int id, Map<String, dynamic> data) async {
    final token = await AuthSession.getToken();

    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data),
    );

    print("UPDATE STATUS: ${res.statusCode}");
    return res.statusCode == 200;
  }
}
