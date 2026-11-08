import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';

class InMemoryRecipeRepository implements RecipeRepository {
  static const Recipe _recipe = Recipe(
    name: 'Student food',
    baseServings: 2,
    ingredients: [
      Ingredient("Хліб", 2, "шт"),
      Ingredient("Мазік", 100, "г"),
      Ingredient("Ковбаса", 200, "г"),
      Ingredient("Кептчуп", 100, "г"),
      Ingredient("Сир", 200, "г"),
      Ingredient("Помідор", 1, "шт"),
    ],
    steps: [
      "Покласти сир на нижню булочку, а потім намастити сир кептчунезом",
      "Нарізати хліб, сир, ковбасу та помідори",
      "Змішати майонез і кетчуп",
      "Покласти сир на нижню булочку, а потім намастити сир кетчунезом",
      "Додати всі інші інгредієнти і смакувати",
      "Насолоджуйтесь",
    ],
  );

  @override
  Recipe getRecipe() => _recipe;
}
