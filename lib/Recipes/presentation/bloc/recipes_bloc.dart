import 'package:bloc/bloc.dart';
import '../../data/models/recipe_request.dart';
import '../../data/repositories/recipes_repository.dart';
import '../../data/models/recipe_model.dart';

part 'recipes_event.dart';
part 'recipes_state.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final RecipesRepository repo = RecipesRepository();

  RecipesBloc() : super(RecipesInitial()) {
    on<CreateTemplateEvent>(_onCreateTemplate);
    on<LoadTemplatesByNutritionistEvent>(_onLoadTemplates);
    on<LoadRecipeByIdEvent>(_onLoadRecipeById);
  }

  Future<void> _onCreateTemplate(CreateTemplateEvent e, Emitter emit) async {
    emit(RecipesLoading());

    final ok = await repo.createRecipeTemplate(e.nutritionistId, e.request);

    ok ? emit(RecipeCreated()) : emit(RecipesError("Error al crear receta"));
  }

  Future<void> _onLoadTemplates(LoadTemplatesByNutritionistEvent e, Emitter emit) async {
    emit(RecipesLoading());

    final templates = await repo.getTemplatesByNutritionist(e.nutritionistId);

    emit(TemplatesLoaded(templates));
  }

  Future<void> _onLoadRecipeById(LoadRecipeByIdEvent e, Emitter emit) async {
    emit(RecipesLoading());

    final recipe = await repo.getRecipeById(e.recipeId);

    if (recipe == null) {
      emit(RecipesError("Receta no encontrada"));
      return;
    }

    emit(RecipeLoaded(recipe));
  }
}
