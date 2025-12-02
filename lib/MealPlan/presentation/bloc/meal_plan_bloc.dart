import 'package:bloc/bloc.dart';

import '../../data/repositories/meal_plan_repository.dart';
import 'meal_plan_event.dart';
import 'meal_plan_state.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  final MealPlanRepository repo = MealPlanRepository();

  MealPlanBloc() : super(MealPlanInitial()) {
    on<CreateMealPlanEvent>(_onCreateMealPlan);
    on<LoadMealPlansEvent>(_onLoadMealPlans);
    on<DeleteMealPlanEvent>(_onDeleteMealPlan);
  }

  Future<void> _onCreateMealPlan(
    CreateMealPlanEvent event,
    Emitter<MealPlanState> emit,
  ) async {
    emit(MealPlanLoading());

    try {
      final result = await repo.createMealPlanTemplate(
        event.nutritionistUserId,
        event.request,
      );

      if (result == null) {
        emit(MealPlanError("No se pudo crear el plan alimenticio"));
        return;
      }

      emit(MealPlanCreated(result));
    } catch (e) {
      emit(MealPlanError("Error interno: $e"));
    }
  }

  Future<void> _onLoadMealPlans(
    LoadMealPlansEvent event,
    Emitter<MealPlanState> emit,
  ) async {
    emit(MealPlanLoading());

    try {
      final result = await repo.getMealPlansByNutritionist(
        event.nutritionistUserId,
      );

      emit(MealPlansLoaded(result));
    } catch (e) {
      emit(MealPlanError("Error interno: $e"));
    }
  }

  Future<void> _onDeleteMealPlan(
    DeleteMealPlanEvent event,
    Emitter<MealPlanState> emit,
  ) async {
    emit(MealPlanLoading());

    try {
      final success = await repo.deleteMealPlan(event.mealPlanId);

      if (!success) {
        emit(MealPlanError("No se pudo eliminar el plan alimenticio"));
        return;
      }

      // Recargar la lista después de eliminar
      final result = await repo.getMealPlansByNutritionist(
        event.nutritionistUserId,
      );

      emit(MealPlansLoaded(result));
    } catch (e) {
      emit(MealPlanError("Error interno: $e"));
    }
  }
}
