import 'package:flutter/foundation.dart';
import 'package:lab_layout/application/use_cases/add_note_use_case.dart';
import 'package:lab_layout/application/use_cases/delete_note_use_case.dart';

class NotesNotifier extends ChangeNotifier {
  final AddNoteUseCase _addNote;
  final DeleteNoteUseCase _deleteNote;

  List<String> _notes = const [];

  NotesNotifier({required this._addNote, required this._deleteNote});

  List<String> get notes => _notes;

  void addNote(String text) {
    _notes = _addNote(text);
    notifyListeners();
  }

  void deleteNote(String note) {
    _notes = _deleteNote(note);
    notifyListeners();
  }
}
