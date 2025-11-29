import 'UserProfileModel.dart';

class NutritionistPatientModel {
  final int id;
  final int nutritionistId;
  final int patientUserId;
  final String serviceType;
  final DateTime? startDate;
  final DateTime? scheduledAt;
  final bool accepted;
  final DateTime requestedAt;

  UserProfileModel? profile;

  NutritionistPatientModel({
    required this.id,
    required this.nutritionistId,
    required this.patientUserId,
    required this.serviceType,
    this.startDate,
    this.scheduledAt,
    required this.accepted,
    required this.requestedAt,
    this.profile,
  });

  factory NutritionistPatientModel.fromJson(Map<String, dynamic> json) {
    return NutritionistPatientModel(
      id: json['id'],
      nutritionistId: json['nutritionistId'],
      patientUserId: json['patientUserId'],
      serviceType: json['serviceType'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      scheduledAt: json['scheduledAt'] != null ? DateTime.parse(json['scheduledAt']) : null,
      accepted: json['accepted'],
      requestedAt: DateTime.parse(json['requestedAt']),
    );
  }

  NutritionistPatientModel copyWithProfile(UserProfileModel profile) {
    return NutritionistPatientModel(
      id: id,
      nutritionistId: nutritionistId,
      patientUserId: patientUserId,
      serviceType: serviceType,
      startDate: startDate,
      scheduledAt: scheduledAt,
      accepted: accepted,
      requestedAt: requestedAt,
      profile: profile,
    );
  }
}
