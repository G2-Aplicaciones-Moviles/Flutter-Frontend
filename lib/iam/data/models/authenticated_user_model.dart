class AuthenticatedUserModel {
  final int id;
  final String token;

  AuthenticatedUserModel({
    required this.id,
    required this.token,
  });

  factory AuthenticatedUserModel.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUserModel(
      id: json["id"],
      token: json["token"],
    );
  }
}
