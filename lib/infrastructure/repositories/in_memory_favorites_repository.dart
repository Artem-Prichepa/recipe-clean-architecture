import '../../domain/repositories/favorites_repository.dart';

class InMemoryFavoritesRepository implements FavoritesRepository {
  final Set<String> _favorites = {};

  @override
  Set<String> getAll() => Set.unmodifiable(_favorites);

  @override
  void add(String name) => _favorites.add(name);

  @override
  void remove(String name) => _favorites.remove(name);
}
