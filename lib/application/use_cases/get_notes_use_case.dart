import '../../domain/repositories/notes_repository.dart';

class GetNotesUseCase {
  final NotesRepository _repository;

  GetNotesUseCase(this._repository);

  List<String> call() => _repository.getAll();
}
