abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoggedIn extends AuthState {
  final int userId;
  final String token;
  AuthLoggedIn(this.userId, this.token);
}

class AuthNeedsProfile extends AuthState {
  final int userId;
  AuthNeedsProfile(this.userId);
}

class AuthRegistered extends AuthState {
  final int userId;
  AuthRegistered(this.userId);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
