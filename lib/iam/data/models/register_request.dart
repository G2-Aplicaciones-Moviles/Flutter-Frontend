class RegisterRequest {
  final String username;
  final String password;
  final List<String> roles;

  RegisterRequest(this.username, this.password, this.roles);

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "roles": roles,
  };
}
