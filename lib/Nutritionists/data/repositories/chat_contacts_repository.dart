import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../iam/services/auth_session.dart';
import '../models/chat_contact_model.dart';

class ChatContactsRepository {
  static const String baseUrl = "http://10.0.2.2:8080/api/v1/chat";

  // In-memory cache
  List<ChatContactModel>? _cachedContacts;

  /// Get contacts (patients) for a nutritionist
  Future<List<ChatContactModel>> getContacts(int nutritionistId) async {
    final token = await AuthSession.getToken();

    try {
      final res = await http.get(
        Uri.parse("$baseUrl/contacts/$nutritionistId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        _cachedContacts = data.map((json) => ChatContactModel.fromJson(json)).toList();
        return _cachedContacts!;
      } else if (res.statusCode == 401) {
        throw Exception("Sesión expirada. Por favor inicia sesión nuevamente.");
      } else if (res.statusCode == 403) {
        throw Exception("No tienes permisos para ver estos contactos.");
      } else if (res.statusCode == 404) {
        _cachedContacts = [];
        return [];
      } else if (res.statusCode >= 500) {
        throw Exception("Servicio no disponible. Intenta más tarde.");
      }

      return _cachedContacts ?? [];
    } catch (e) {
      print("Error fetching contacts: $e");
      if (e is Exception) rethrow;
      return _cachedContacts ?? [];
    }
  }

  /// Validate if nutritionist can chat with patient
  Future<bool> validate(int nutritionistId, int patientId) async {
    final token = await AuthSession.getToken();

    try {
      final res = await http.get(
        Uri.parse("$baseUrl/validate?userId1=$nutritionistId&userId2=$patientId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['canChat'] as bool? ?? false;
      } else if (res.statusCode == 401) {
        throw Exception("Sesión expirada. Por favor inicia sesión nuevamente.");
      } else if (res.statusCode == 403) {
        throw Exception("No tienes permiso para chatear con este paciente.");
      } else if (res.statusCode == 404) {
        throw Exception("Usuario no encontrado. Intenta más tarde.");
      } else if (res.statusCode >= 500) {
        throw Exception("Servicio no disponible. Intenta más tarde.");
      }

      return false;
    } catch (e) {
      print("Error validating chat: $e");
      if (e is Exception) rethrow;
      return false;
    }
  }

  /// Clear cache to force refresh
  void clearCache() {
    _cachedContacts = null;
  }
}

