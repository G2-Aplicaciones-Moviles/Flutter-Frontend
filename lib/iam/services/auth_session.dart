import 'package:shared_preferences/shared_preferences.dart';

class AuthSession {
  static const _tokenKey = "auth_token";
  static const _userIdKey = "auth_user_id";

  /// Guarda el token y el ID del usuario
  static Future<void> saveSession(String token, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_userIdKey, userId);
  }

  /// Obtiene el token guardado
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Obtiene el ID del usuario guardado
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  static Future<void> saveNutritionistId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("nutritionistId", id);
  }

  static Future<int?> getNutritionistId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("nutritionistId");
  }

  /// Limpia todo (al cerrar sesión)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
