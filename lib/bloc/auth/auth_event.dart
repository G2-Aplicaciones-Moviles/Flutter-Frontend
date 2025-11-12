import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;
  const LoginSubmitted(this.username, this.password);
  @override
  List<Object?> get props => [username, password];
}

class RegisterSubmitted extends AuthEvent {
  final String username;
  final String password;
  const RegisterSubmitted(this.username, this.password);
  @override
  List<Object?> get props => [username, password];
}

class LoggedOut extends AuthEvent {}
