abstract interface class FavoritesRepository {
  Set<String> getAll();
  void add(String name);
  void remove(String name);
}
