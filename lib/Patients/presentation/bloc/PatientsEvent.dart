part of 'PatientsBloc.dart';

abstract class PatientsEvent {}

/// Evento principal: cargar pacientes del nutricionista
class FetchPatientsEvent extends PatientsEvent {
  final int nutritionistId;

  FetchPatientsEvent(this.nutritionistId);
}
