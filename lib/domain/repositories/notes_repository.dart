abstract interface class NotesRepository {
  List<String> getAll();
  void add(String text);
  void remove(String text);
}
