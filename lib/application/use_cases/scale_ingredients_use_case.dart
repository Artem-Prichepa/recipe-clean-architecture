import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';

class ScaleIngredientsUseCase {
  List<Ingredient> call(Recipe recipe, int servings) {
    return recipe.ingredients
        .map(
          (i) => Ingredient(
            i.name,
            i.amount * servings / recipe.baseServings,
            i.unit,
          ),
        )
        .toList();
  }
}
