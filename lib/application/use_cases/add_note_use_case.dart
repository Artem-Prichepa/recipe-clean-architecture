import '../../domain/repositories/notes_repository.dart';

class AddNoteUseCase {
  final NotesRepository _repository;

  AddNoteUseCase(this._repository);

  List<String> call(String text) {
    final trimmed = text.trim();
    if (trimmed.isNotEmpty) _repository.add(trimmed);
    return _repository.getAll();
  }
}
