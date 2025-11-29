import 'package:bloc/bloc.dart';

import '../../data/models/NutritionistPatientModel.dart';
import '../../data/repositories/PatientsRepository.dart';
import '../../data/repositories/UserProfileRepository.dart';
part 'PatientsEvent.dart';
part 'PatientsState.dart';








class PatientsBloc extends Bloc<PatientsEvent, PatientsState> {
  final PatientsRepository patientsRepo = PatientsRepository();
  final UserProfileRepository profileRepo = UserProfileRepository();

  PatientsBloc() : super(PatientsInitial()) {
    on<FetchPatientsEvent>(_onFetchPatients);
  }

  Future<void> _onFetchPatients(
      FetchPatientsEvent event, Emitter<PatientsState> emit) async {

    emit(PatientsLoadingState());

    try {
      final patients = await patientsRepo.fetchPatients(event.nutritionistId);
      final List<NutritionistPatientModel> enriched = [];

      for (final p in patients) {
        final profile = await profileRepo.fetchProfile(p.patientUserId);
        enriched.add(
          profile != null ? p.copyWithProfile(profile) : p,
        );
      }

      emit(PatientsLoadedState(patients: enriched));
    } catch (e) {
      emit(PatientsErrorState("Error al cargar pacientes"));
    }
  }
}
