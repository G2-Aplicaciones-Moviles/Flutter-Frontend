import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../iam/services/auth_session.dart';
import '../models/nutritionist_request_model.dart';

class NutritionistRequestsRepository {
  static const String baseUrl = "http://10.0.2.2:8080/api/v1/requests";

  /// Get pending requests for a nutritionist
  Future<List<NutritionistRequestModel>> getPending(int nutritionistId) async {
    final token = await AuthSession.getToken();
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/nutritionist/$nutritionistId/pending"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((json) => NutritionistRequestModel.fromJson(json)).toList();
      } else if (res.statusCode == 401) {
        throw Exception("Sesión expirada. Por favor inicia sesión nuevamente.");
      } else if (res.statusCode == 403) {
        throw Exception("No tienes permisos para ver estas solicitudes.");
      } else if (res.statusCode == 404) {
        return []; // No requests found
      } else if (res.statusCode >= 500) {
        throw Exception("Servicio no disponible. Intenta más tarde.");
      }
      return [];
    } catch (e) {
      print("Error fetching pending requests: $e");
      rethrow;
    }
  }

  /// Approve a request
  Future<bool> approve(int requestId) async {
    final token = await AuthSession.getToken();
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/$requestId/approve"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200 || res.statusCode == 204) {
        return true;
      } else if (res.statusCode == 401) {
        throw Exception("Sesión expirada. Por favor inicia sesión nuevamente.");
      } else if (res.statusCode == 403) {
        throw Exception("No tienes permisos para aprobar esta solicitud.");
      } else if (res.statusCode == 404) {
        throw Exception("Solicitud no encontrada.");
      } else if (res.statusCode == 409) {
        throw Exception("La solicitud ya fue procesada.");
      } else if (res.statusCode >= 500) {
        throw Exception("Servicio no disponible. Intenta más tarde.");
      }
      return false;
    } catch (e) {
      print("Error approving request: $e");
      rethrow;
    }
  }

  /// Reject a request
  Future<bool> reject(int requestId) async {
    final token = await AuthSession.getToken();
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/$requestId/reject"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200 || res.statusCode == 204) {
        return true;
      } else if (res.statusCode == 401) {
        throw Exception("Sesión expirada. Por favor inicia sesión nuevamente.");
      } else if (res.statusCode == 403) {
        throw Exception("No tienes permisos para rechazar esta solicitud.");
      } else if (res.statusCode == 404) {
        throw Exception("Solicitud no encontrada.");
      } else if (res.statusCode == 409) {
        throw Exception("La solicitud ya fue procesada.");
      } else if (res.statusCode >= 500) {
        throw Exception("Servicio no disponible. Intenta más tarde.");
      }
      return false;
    } catch (e) {
      print("Error rejecting request: $e");
      rethrow;
    }
  }
}