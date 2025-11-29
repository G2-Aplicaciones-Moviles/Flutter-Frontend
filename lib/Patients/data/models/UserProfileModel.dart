class UserProfileModel {
  final int id;
  final String gender;
  final double height;
  final double weight;
  final int userScore;
  final String birthDate;
  final int activityLevelId;
  final String activityLevelName;
  final int objectiveId;
  final String objectiveName;
  final List<String> allergyNames;

  UserProfileModel({
    required this.id,
    required this.gender,
    required this.height,
    required this.weight,
    required this.userScore,
    required this.birthDate,
    required this.activityLevelId,
    required this.activityLevelName,
    required this.objectiveId,
    required this.objectiveName,
    required this.allergyNames,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      gender: json['gender'] ?? "",
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      userScore: json['userScore'] ?? 0,
      birthDate: json['birthDate'] ?? "",
      activityLevelId: (json['activityLevelId'] ?? 0).toInt(),
      activityLevelName: json['activityLevelName'] ?? "",
      objectiveId: (json['objectiveId'] ?? 0).toInt(),
      objectiveName: json['objectiveName'] ?? "",
      allergyNames: List<String>.from(json['allergyNames'] ?? []),
    );
  }

  String get fullGender => gender == "M" ? "Masculino" : "Femenino";
}
