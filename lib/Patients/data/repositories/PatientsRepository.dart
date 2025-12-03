import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../iam/services/auth_session.dart';
import '../models/NutritionistPatientModel.dart';

class PatientsRepository {
  static const String baseUrl =
      "http://10.0.2.2:8080/api/v1/nutritionist-patients";

  Future<List<NutritionistPatientModel>> fetchPatients(int nutritionistId) async {
    final url = Uri.parse("$baseUrl/nutritionist/$nutritionistId");
    final token = await AuthSession.getToken(); // ✔ TOKEN REAL

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✔ TOKEN MANDADO
        },
      );

      if (response.statusCode == 200) {
        final List decoded = jsonDecode(response.body);

        return decoded
            .map((json) => NutritionistPatientModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Error ${response.statusCode} al cargar pacientes");
      }
    } catch (e) {
      print("❌ Error en fetchPatients: $e");
      return [];
    }
  }

  Future<bool> approvePatient(int relationId) async {
    final token = await AuthSession.getToken();
    final url = Uri.parse("$baseUrl/$relationId/approve");

    try {
      final response = await http.put(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error en approvePatient: $e");
      return false;
    }
  }

  Future<bool> deletePatient(int relationId) async {
    final token = await AuthSession.getToken();

    final url = Uri.parse(baseUrl); // DELETE no usa path extra

    try {
      final response = await http.delete(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "id": relationId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error en deletePatient: $e");
      return false;
    }
  }

}
