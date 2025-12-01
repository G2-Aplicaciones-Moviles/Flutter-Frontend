class NutritionistProfileRequest {
  final int userId;
  final String fullName;
  final String licenseNumber;
  final String specialty;
  final int yearsExperience;
  final String bio;
  final bool acceptingNewPatients;
  final String profilePictureUrl;

  NutritionistProfileRequest({
    required this.userId,
    required this.fullName,
    required this.licenseNumber,
    required this.specialty,
    required this.yearsExperience,
    required this.bio,
    required this.acceptingNewPatients,
    this.profilePictureUrl = "",
  });

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "fullName": fullName,
    "licenseNumber": licenseNumber,
    "specialty": specialty,
    "yearsExperience": yearsExperience,
    "bio": bio,
    "acceptingNewPatients": acceptingNewPatients,
    "profilePictureUrl": profilePictureUrl,
  };
}
