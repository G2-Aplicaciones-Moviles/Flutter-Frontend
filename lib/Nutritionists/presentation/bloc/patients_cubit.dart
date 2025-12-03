import 'package:bloc/bloc.dart';
import '../../data/models/chat_contact_model.dart';
import '../../data/repositories/chat_contacts_repository.dart';

// States
abstract class PatientsState {}

class PatientsInitial extends PatientsState {}

class PatientsLoading extends PatientsState {}

class PatientsLoaded extends PatientsState {
  final List<ChatContactModel> patients;
  PatientsLoaded(this.patients);
}

class PatientsError extends PatientsState {
  final String message;
  PatientsError(this.message);
}

class PatientsValidating extends PatientsState {}

class PatientsValidationSuccess extends PatientsState {
  final int patientId;
  PatientsValidationSuccess(this.patientId);
}

class PatientsValidationFailed extends PatientsState {
  final String message;
  PatientsValidationFailed(this.message);
}

// Cubit
class PatientsCubit extends Cubit<PatientsState> {
  final ChatContactsRepository _repository;

  PatientsCubit(this._repository) : super(PatientsInitial());

  Future<void> loadPatients(int nutritionistId) async {
    emit(PatientsLoading());

    try {
      final patients = await _repository.getContacts(nutritionistId);

      // Sort by lastMessageAt (most recent first) or by name
      patients.sort((a, b) {
        if (a.lastMessageAt != null && b.lastMessageAt != null) {
          return b.lastMessageAt!.compareTo(a.lastMessageAt!);
        }
        if (a.lastMessageAt != null) return -1;
        if (b.lastMessageAt != null) return 1;
        return a.name.compareTo(b.name);
      });

      emit(PatientsLoaded(patients));
    } catch (e) {
      emit(PatientsError("Error al cargar pacientes: $e"));
    }
  }

  Future<void> validateAndNavigate(int nutritionistId, int patientId) async {
    emit(PatientsValidating());

    try {
      final canChat = await _repository.validate(nutritionistId, patientId);

      if (canChat) {
        emit(PatientsValidationSuccess(patientId));
      } else {
        emit(PatientsValidationFailed(
            "Relación no aceptada o expirada. No puedes chatear con este paciente."));
      }
    } catch (e) {
      emit(PatientsValidationFailed("Error al validar relación: $e"));
    }
  }

  Future<void> refresh(int nutritionistId) async {
    _repository.clearCache();
    await loadPatients(nutritionistId);
  }
}

