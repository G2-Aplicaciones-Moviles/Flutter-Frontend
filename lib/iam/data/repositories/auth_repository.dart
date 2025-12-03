import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/authenticated_user_model.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

class AuthRepository {
  static const String baseUrl = "http://10.0.2.2:8080/api/v1/authentication";

  Future<AuthenticatedUserModel?> login(LoginRequest request) async {
    final url = Uri.parse("$baseUrl/sign-in");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return AuthenticatedUserModel.fromJson(data);
    }

    return null;
  }

  Future<int?> register(RegisterRequest request) async {
    final url = Uri.parse("$baseUrl/sign-up");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return data["id"] as int?;
    }
    return null;
  }
}
