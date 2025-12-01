abstract class NutritionistState {}

class NutritionistInitial extends NutritionistState {}

class NutritionistLoading extends NutritionistState {}

class NutritionistCreated extends NutritionistState {}

class NutritionistError extends NutritionistState {
  final String message;

  NutritionistError(this.message);
}
