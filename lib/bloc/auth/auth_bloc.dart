import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../core/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepo;

  AuthBloc(this.authRepo) : super(AuthState.unknown()) {
    on<AppStarted>(_onAppStarted);
    on<LoginSubmitted>(_onLogin);
    on<RegisterSubmitted>(_onRegister);
    on<LoggedOut>(_onLogout);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) {
    final user = authRepo.getCurrentUser();
    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(AuthState.unauthenticated());
    }
  }

  Future<void> _onLogin(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    try {
      final user = await authRepo.logIn(event.username, event.password);
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.unauthenticated("Usuario o contraseña incorrectos"));
    }
  }

  Future<void> _onRegister(RegisterSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    try {
      final user = await authRepo.register(event.username, event.password);
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.unauthenticated("No se pudo registrar"));
    }
  }

  Future<void> _onLogout(LoggedOut event, Emitter<AuthState> emit) async {
    await authRepo.logOut();
    emit(AuthState.unauthenticated());
  }
}
