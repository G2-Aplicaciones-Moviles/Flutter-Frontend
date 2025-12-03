part of 'PatientsBloc.dart';

abstract class PatientsEvent {}

/// Evento principal: cargar pacientes del nutricionista
class FetchPatientsEvent extends PatientsEvent {
  final int nutritionistId;

  FetchPatientsEvent(this.nutritionistId);
}

class ApprovePatientEvent extends PatientsEvent {
  final int relationId;
  final int nutritionistId;

  ApprovePatientEvent(this.relationId, this.nutritionistId);
}

class DeletePatientEvent extends PatientsEvent {
  final int relationId;
  final int nutritionistId;

  DeletePatientEvent(this.relationId, this.nutritionistId);
}