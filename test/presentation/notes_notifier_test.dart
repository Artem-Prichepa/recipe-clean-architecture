import 'package:flutter_test/flutter_test.dart';
import 'package:lab_layout/application/use_cases/add_note_use_case.dart';
import 'package:lab_layout/application/use_cases/delete_note_use_case.dart';
import 'package:lab_layout/application/use_cases/get_notes_use_case.dart';
import 'package:lab_layout/presentation/notifiers/notes_notifier.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNotesUseCase extends Mock implements GetNotesUseCase {}

class MockAddNoteUseCase extends Mock implements AddNoteUseCase {}

class MockDeleteNoteUseCase extends Mock implements DeleteNoteUseCase {}

void main() {
  late MockGetNotesUseCase getNotes;
  late MockAddNoteUseCase addNote;
  late MockDeleteNoteUseCase deleteNote;
  late int listenerCalls;

  NotesNotifier createNotifier() {
    final notifier = NotesNotifier(
      getNotes: getNotes,
      addNote: addNote,
      deleteNote: deleteNote,
    );
    notifier.addListener(() => listenerCalls++);
    return notifier;
  }

  setUp(() {
    getNotes = MockGetNotesUseCase();
    addNote = MockAddNoteUseCase();
    deleteNote = MockDeleteNoteUseCase();
    listenerCalls = 0;
    when(() => getNotes()).thenReturn(<String>[]);
  });

  test('початковий стан береться з GetNotesUseCase', () {
    when(() => getNotes()).thenReturn(['збережена']);

    final notifier = createNotifier();

    expect(notifier.notes, ['збережена']);
    expect(listenerCalls, 0);
  });

  test('addNote оновлює список і сповіщує listener один раз', () {
    when(() => addNote('Купити сіль')).thenReturn(['Купити сіль']);
    final notifier = createNotifier();

    notifier.addNote('Купити сіль');

    expect(notifier.notes, ['Купити сіль']);
    expect(listenerCalls, 1);
    verify(() => addNote('Купити сіль')).called(1);
  });

  test('deleteNote оновлює список і сповіщує listener один раз', () {
    when(() => getNotes()).thenReturn(['Купити сіль']);
    when(() => deleteNote('Купити сіль')).thenReturn(<String>[]);
    final notifier = createNotifier();

    notifier.deleteNote('Купити сіль');

    expect(notifier.notes, isEmpty);
    expect(listenerCalls, 1);
    verify(() => deleteNote('Купити сіль')).called(1);
  });
}
