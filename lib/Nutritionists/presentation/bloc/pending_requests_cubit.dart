import 'package:bloc/bloc.dart';
import '../../data/models/nutritionist_request_model.dart';
import '../../data/repositories/nutritionist_requests_repository.dart';
import '../../data/repositories/chat_contacts_repository.dart';

// States
abstract class PendingRequestsState {}

class PendingRequestsInitial extends PendingRequestsState {}

class PendingRequestsLoading extends PendingRequestsState {}

class PendingRequestsLoaded extends PendingRequestsState {
  final List<NutritionistRequestModel> requests;
  PendingRequestsLoaded(this.requests);
}

class PendingRequestsError extends PendingRequestsState {
  final String message;
  PendingRequestsError(this.message);
}

class PendingRequestsProcessing extends PendingRequestsState {
  final int requestId;
  PendingRequestsProcessing(this.requestId);
}

// Cubit
class PendingRequestsCubit extends Cubit<PendingRequestsState> {
  final NutritionistRequestsRepository _requestsRepo;
  final ChatContactsRepository _contactsRepo;

  PendingRequestsCubit(this._requestsRepo, this._contactsRepo)
      : super(PendingRequestsInitial());

  Future<void> loadRequests(int nutritionistId) async {
    emit(PendingRequestsLoading());
    try {
      final requests = await _requestsRepo.getPending(nutritionistId);
      emit(PendingRequestsLoaded(requests));
    } catch (e) {
      emit(PendingRequestsError("Error al cargar solicitudes: $e"));
    }
  }

  Future<void> approveRequest(int requestId, int nutritionistId) async {
    emit(PendingRequestsProcessing(requestId));
    try {
      final success = await _requestsRepo.approve(requestId);

      if (success) {
        // Clear contacts cache to refresh the patients list
        _contactsRepo.clearCache();
        // Reload requests
        await loadRequests(nutritionistId);
      } else {
        emit(PendingRequestsError("No se pudo aprobar la solicitud"));
        await loadRequests(nutritionistId);
      }
    } catch (e) {
      emit(PendingRequestsError("Error al aprobar solicitud: $e"));
      await loadRequests(nutritionistId);
    }
  }

  Future<void> rejectRequest(int requestId, int nutritionistId) async {
    emit(PendingRequestsProcessing(requestId));
    try {
      final success = await _requestsRepo.reject(requestId);

      if (success) {
        await loadRequests(nutritionistId);
      } else {
        emit(PendingRequestsError("No se pudo rechazar la solicitud"));
        await loadRequests(nutritionistId);
      }
    } catch (e) {
      emit(PendingRequestsError("Error al rechazar solicitud: $e"));
      await loadRequests(nutritionistId);
    }
  }

  Future<void> refresh(int nutritionistId) async {
    await loadRequests(nutritionistId);
  }
}