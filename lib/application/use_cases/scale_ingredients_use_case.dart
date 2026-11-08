import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';

class ScaleIngredientsUseCase {
  List<Ingredient> call(Recipe recipe, int servings) {
    if (servings < 1) {
      throw ArgumentError.value(
        servings,
        'servings',
        'Кількість порцій має бути не менше 1',
      );
    }
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
