import '../../domain/repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  final FavoritesRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Set<String> call(String name) {
    if (_repository.getAll().contains(name)) {
      _repository.remove(name);
    } else {
      _repository.add(name);
    }
    return _repository.getAll();
  }
}
