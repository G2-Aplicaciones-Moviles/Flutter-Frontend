abstract class NutritionistEvent {}

class CreateNutritionistEvent extends NutritionistEvent {
  final int userId;
  final String fullName;
  final String licenseNumber;
  final String specialty;
  final int yearsExperience;
  final String bio;
  final bool acceptingNewPatients;

  CreateNutritionistEvent({
    required this.userId,
    required this.fullName,
    required this.licenseNumber,
    required this.specialty,
    required this.yearsExperience,
    required this.bio,
    required this.acceptingNewPatients,
  });
}
