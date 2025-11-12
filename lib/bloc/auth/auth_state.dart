import 'package:equatable/equatable.dart';

enum AuthStatus { unknown, loading, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? user;
  final String? error;

  const AuthState({
    required this.status,
    this.user,
    this.error,
  });

  factory AuthState.unknown() => const AuthState(status: AuthStatus.unknown);
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);
  factory AuthState.authenticated(String user) =>
      AuthState(status: AuthStatus.authenticated, user: user);
  factory AuthState.unauthenticated([String? error]) =>
      AuthState(status: AuthStatus.unauthenticated, error: error);

  @override
  List<Object?> get props => [status, user, error];
}
