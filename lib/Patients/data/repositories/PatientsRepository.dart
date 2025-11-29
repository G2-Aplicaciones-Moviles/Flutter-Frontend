import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/NutritionistPatientModel.dart';

class PatientsRepository {
  static const String baseUrl =
      "http://10.0.2.2:5000/api/v1/nutritionist-patients";

  /// Obtiene la lista de pacientes asociados a un nutricionista
  Future<List<NutritionistPatientModel>> fetchPatients(int nutritionistId) async {
    final url = Uri.parse("$baseUrl/nutritionist/$nutritionistId");

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List decoded = jsonDecode(response.body);

        // Mapea cada elemento al modelo
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
}
