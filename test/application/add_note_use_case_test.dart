import 'package:flutter_test/flutter_test.dart';
import 'package:lab_layout/application/use_cases/add_note_use_case.dart';
import 'package:lab_layout/domain/repositories/notes_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  late MockNotesRepository repository;
  late AddNoteUseCase useCase;

  setUp(() {
    repository = MockNotesRepository();
    useCase = AddNoteUseCase(repository);
    when(() => repository.getAll()).thenReturn(<String>[]);
  });

  test('обрізає пробіли перед додаванням нотатки', () {
    useCase('  Купити сіль  ');

    verify(() => repository.add('Купити сіль')).called(1);
  });

  test('не додає порожній текст', () {
    useCase('');

    verifyNever(() => repository.add(any()));
  });

  test('не додає текст із самих пробілів', () {
    useCase('   \t ');

    verifyNever(() => repository.add(any()));
  });

  test('повертає список із репозиторію після додавання', () {
    when(() => repository.getAll()).thenReturn(['Купити сіль']);

    final result = useCase('Купити сіль');

    expect(result, ['Купити сіль']);
    verify(() => repository.getAll()).called(1);
  });

  test('повертає поточний список, коли текст порожній', () {
    when(() => repository.getAll()).thenReturn(['стара']);

    final result = useCase('  ');

    expect(result, ['стара']);
  });
}
