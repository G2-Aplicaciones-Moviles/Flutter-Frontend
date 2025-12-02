import '../../data/models/meal_plan_model.dart';

abstract class MealPlanState {}

class MealPlanInitial extends MealPlanState {}

class MealPlanLoading extends MealPlanState {}

class MealPlanCreated extends MealPlanState {
  final MealPlanModel mealPlan;
  MealPlanCreated(this.mealPlan);
}

class MealPlansLoaded extends MealPlanState {
  final List<MealPlanModel> mealPlans;
  MealPlansLoaded(this.mealPlans);
}

class MealPlanDeleted extends MealPlanState {}

class MealPlanError extends MealPlanState {
  final String message;
  MealPlanError(this.message);
}
