import 'package:flutter/foundation.dart';
import 'package:lab_layout/application/use_cases/get_recipe_use_case.dart';
import 'package:lab_layout/application/use_cases/scale_ingredients_use_case.dart';
import 'package:lab_layout/application/use_cases/toggle_favorite_use_case.dart';
import 'package:lab_layout/domain/entities/ingredient.dart';
import 'package:lab_layout/domain/entities/recipe.dart';

class RecipeNotifier extends ChangeNotifier {
  final ScaleIngredientsUseCase _scaleIngredients;
  final ToggleFavoriteUseCase _toggleFavorite;

  final Recipe recipe;
  late int _servings;
  late List<Ingredient> _ingredients;
  Set<String> _favorites = const {};

  RecipeNotifier({
    required GetRecipeUseCase getRecipe,
    required this._scaleIngredients,
    required this._toggleFavorite,
  }) : recipe = getRecipe() {
    _servings = recipe.baseServings;
    _ingredients = _scaleIngredients(recipe, _servings);
  }

  int get servings => _servings;
  List<Ingredient> get ingredients => _ingredients;
  Set<String> get favorites => _favorites;
  bool isFavorite(String dish) => _favorites.contains(dish);

  void setServings(int value) {
    if (value < 1 || value > 12) return;
    _servings = value;
    _ingredients = _scaleIngredients(recipe, _servings);
    notifyListeners();
  }

  void toggleFavorite(String dish) {
    _favorites = _toggleFavorite(dish);
    notifyListeners();
  }
}
