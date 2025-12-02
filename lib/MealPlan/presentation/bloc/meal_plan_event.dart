import '../../data/models/create_meal_plan_request.dart';

abstract class MealPlanEvent {}

class CreateMealPlanEvent extends MealPlanEvent {
  final int nutritionistUserId;
  final CreateMealPlanRequest request;

  CreateMealPlanEvent(this.nutritionistUserId, this.request);
}

class LoadMealPlansEvent extends MealPlanEvent {
  final int nutritionistUserId;

  LoadMealPlansEvent(this.nutritionistUserId);
}

class DeleteMealPlanEvent extends MealPlanEvent {
  final int mealPlanId;
  final int nutritionistUserId;

  DeleteMealPlanEvent(this.mealPlanId, this.nutritionistUserId);
}
