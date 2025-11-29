part of 'PatientsBloc.dart';

abstract class PatientsState {}

/// Estado inicial
class PatientsInitial extends PatientsState {}

/// Estado mientras se cargan pacientes
class PatientsLoadingState extends PatientsState {}

/// Estado cuando se cargaron correctamente
class PatientsLoadedState extends PatientsState {
  final List<NutritionistPatientModel> patients;

  PatientsLoadedState({required this.patients});
}

/// Estado de error
class PatientsErrorState extends PatientsState {
  final String message;
  PatientsErrorState(this.message);
}
