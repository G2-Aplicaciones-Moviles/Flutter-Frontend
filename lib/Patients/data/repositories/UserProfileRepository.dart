import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../iam/services/auth_session.dart';
import '../models/UserProfileModel.dart';

class UserProfileRepository {
  static const String baseUrl =
      "http://10.0.2.2:5000/api/v1/user-profiles";

  Future<UserProfileModel?> fetchProfile(int userId) async {
    final url = Uri.parse("$baseUrl/$userId");
    final token = await AuthSession.getToken(); // ✔ TOKEN REAL

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✔ SE ENVÍA TOKEN
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        return UserProfileModel.fromJson(decoded);
      } else {
        throw Exception("Error ${response.statusCode} al cargar perfil");
      }
    } catch (e) {
      print("❌ Error en fetchProfile: $e");
      return null;
    }
  }
}
