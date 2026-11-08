import 'package:flutter/foundation.dart';

class RecipeNotifier extends ChangeNotifier{
  int _servings = 2;
  final Set<String> _favorites = {};

  int get servings => _servings;
  Set<String> get favorites => Set.unmodifiable(_favorites);
  bool isFavorite(String dish) => _favorites.contains(dish);

  void setServings(int value) {
    if (value < 1 || value > 12) return;
    _servings = value;
    notifyListeners();
  }

  void toggleFavorite(String dish){
    if (_favorites.contains(dish)){
      _favorites.remove(dish);
    } else{
      _favorites.add(dish);
    }
    notifyListeners();
  }
}