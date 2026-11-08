import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';

class GetRecipeUseCase {
  final RecipeRepository _repository;

  GetRecipeUseCase(this._repository);

  Recipe call() => _repository.getRecipe();
}
