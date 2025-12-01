import 'package:bloc/bloc.dart';

import '../../data/repositories/nutritionist_repository.dart';
import '../../data/models/nutritionist_profile_request.dart';

import 'nutritionist_event.dart';
import 'nutritionist_state.dart';

class NutritionistBloc extends Bloc<NutritionistEvent, NutritionistState> {
  final NutritionistRepository repo = NutritionistRepository();

  NutritionistBloc() : super(NutritionistInitial()) {
    on<CreateNutritionistEvent>(_onCreate);
  }

  Future<void> _onCreate(CreateNutritionistEvent e, Emitter<NutritionistState> emit) async {
    emit(NutritionistLoading());

    final request = NutritionistProfileRequest(
      userId: e.userId,
      fullName: e.fullName,
      licenseNumber: e.licenseNumber,
      specialty: e.specialty,
      yearsExperience: e.yearsExperience,
      bio: e.bio,
      acceptingNewPatients: e.acceptingNewPatients,
    );

    final ok = await repo.createNutritionist(request.toJson());

    if (!ok) {
      emit(NutritionistError("Error al crear nutricionista"));
      return;
    }

    emit(NutritionistCreated());
  }

}
