import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../iam/services/auth_session.dart';

class NutritionistRepository {
  static const String baseUrl = "http://10.0.2.2:5000/api/v1/nutritionists";

  Future<bool> nutritionistExists(int userId) async {
    final token = await AuthSession.getToken();

    final res = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    // Si falla por token inválido, NO debemos decir que "no existe"
    if (res.statusCode != 200) {
      print("Error al consultar nutricionistas: ${res.statusCode}");
      return true; // evitar registro duplicado
    }

    final list = jsonDecode(res.body);
    return list.any((n) => n["userId"] == userId);
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

    return res.statusCode == 200 || res.statusCode == 201;
  }

}
