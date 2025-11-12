import 'dart:async';

class AuthRepository {
  String? _currentUser;

  Future<String> logIn(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (username == "Maria@gmail.com" && password == "1234") {
      _currentUser = username;
      return username;
    }
    throw Exception("Credenciales incorrectas");
  }

  Future<String> register(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = username;
    return username;
  }

  Future<void> logOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  String? getCurrentUser() => _currentUser;
}
