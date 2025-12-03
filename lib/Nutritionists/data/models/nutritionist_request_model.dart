class NutritionistRequestModel {
  final int id;
  final int patientId;
  final String patientName;
  final String? patientEmail;
  final String service;
  final DateTime requestedDate;
  final DateTime? proposedDate;
  final String status; // PENDING, APPROVED, REJECTED

  NutritionistRequestModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    this.patientEmail,
    required this.service,
    required this.requestedDate,
    this.proposedDate,
    required this.status,
  });

  factory NutritionistRequestModel.fromJson(Map<String, dynamic> json) {
    return NutritionistRequestModel(
      id: json['id'] as int,
      patientId: json['patientId'] as int,
      patientName: json['patientName'] as String? ?? 'Paciente',
      patientEmail: json['patientEmail'] as String?,
      service: json['service'] as String? ?? 'Consulta general',
      requestedDate: DateTime.parse(json['requestedDate'] as String),
      proposedDate: json['proposedDate'] != null
          ? DateTime.parse(json['proposedDate'] as String)
          : null,
      status: json['status'] as String? ?? 'PENDING',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'patientEmail': patientEmail,
      'service': service,
      'requestedDate': requestedDate.toIso8601String(),
      'proposedDate': proposedDate?.toIso8601String(),
      'status': status,
    };
  }
}

