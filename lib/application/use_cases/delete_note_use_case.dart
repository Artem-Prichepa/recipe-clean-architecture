import '../../domain/repositories/notes_repository.dart';

class DeleteNoteUseCase {
  final NotesRepository _repository;

  DeleteNoteUseCase(this._repository);

  List<String> call(String text) {
    _repository.remove(text);
    return _repository.getAll();
  }
}
