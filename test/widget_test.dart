import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_layout/application/use_cases/add_note_use_case.dart';
import 'package:lab_layout/application/use_cases/delete_note_use_case.dart';
import 'package:lab_layout/infrastructure/repositories/in_memory_notes_repository.dart';
import 'package:lab_layout/main.dart';
import 'package:lab_layout/presentation/notifiers/notes_notifier.dart';

void main() {
  testWidgets('показує рецепт і перераховує інгредієнти за порціями', (
    tester,
  ) async {
    await tester.pumpWidget(createApp());

    expect(find.text("Назва страви: 'Student food'"), findsOneWidget);
    expect(find.text('2 шт'), findsOneWidget); // Хліб, 2 порції
    expect(find.text('200 г'), findsNWidgets(2)); // Ковбаса, Сир

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('3'), findsOneWidget); // кількість порцій
    expect(find.text('3 шт'), findsOneWidget); // Хліб, 3 порції
    expect(find.text('300 г'), findsNWidgets(2));
  });

  testWidgets('перемикає улюблене', (tester) async {
    await tester.pumpWidget(createApp());

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();
    expect(find.byIcon(Icons.favorite_border), findsNothing);
  });

  testWidgets('вкладка «Кроки» показує кроки рецепта', (tester) async {
    await tester.pumpWidget(createApp());

    expect(find.text('Насолоджуйтесь'), findsNothing);
    await tester.tap(find.text('Кроки'));
    await tester.pump();
    expect(find.text('Насолоджуйтесь'), findsOneWidget);
  });

  test('NotesNotifier додає та видаляє нотатки через use cases', () {
    final repository = InMemoryNotesRepository();
    final notifier = NotesNotifier(
      addNote: AddNoteUseCase(repository),
      deleteNote: DeleteNoteUseCase(repository),
    );

    notifier.addNote('  купити сир  ');
    notifier.addNote('   ');
    expect(notifier.notes, ['купити сир']);

    notifier.deleteNote('купити сир');
    expect(notifier.notes, isEmpty);
  });
}
