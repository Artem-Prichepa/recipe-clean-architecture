import '../../domain/repositories/notes_repository.dart';

class InMemoryNotesRepository implements NotesRepository {
  final List<String> _notes = [];

  @override
  List<String> getAll() => List.unmodifiable(_notes);

  @override
  void add(String text) => _notes.add(text);

  @override
  void remove(String text) => _notes.remove(text);
}
