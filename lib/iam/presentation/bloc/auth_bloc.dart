import 'package:bloc/bloc.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';

import 'auth_event.dart';
import 'auth_state.dart';
import '../../services/auth_session.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
  }

  // LOGIN
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final result = await repo.login(
        LoginRequest(event.email, event.password),
      );

      if (result == null) {
        emit(AuthError("Credenciales inválidas"));
        return;
      }

      // ✔ Guardar sesión local (token + id)
      await AuthSession.saveSession(result.token, result.id);

      emit(AuthLoggedIn(result.id, result.token));
    } catch (e) {
      emit(AuthError("Error interno: $e"));
    }
  }

  // REGISTER
  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final ok = await repo.register(
        RegisterRequest(
          event.email,
          event.password,
          ["ROLE_NUTRITIONIST"],
        ),
      );

      if (!ok) {
        emit(AuthError("No se pudo registrar usuario"));
        return;
      }

      emit(AuthRegistered());
    } catch (e) {
      emit(AuthError("Error interno: $e"));
    }
  }
}
