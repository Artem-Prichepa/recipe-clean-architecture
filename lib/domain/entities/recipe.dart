import 'ingredient.dart';

class Recipe {
  final String name;
  final int baseServings;
  final List<Ingredient> ingredients;
  final List<String> steps;

  const Recipe({
    required this.name,
    required this.baseServings,
    required this.ingredients,
    required this.steps,
  });
}
