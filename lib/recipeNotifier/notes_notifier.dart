import 'package:flutter/foundation.dart';

class NotesNotifier extends ChangeNotifier  {                  
  final List<String> _notes = [];                

  List<String> get notes => List.unmodifiable(_notes);   

  void addNote(String text) {
    _notes.add(text);                           
    notifyListeners();                                  
  }

  void deleteNote(String note) {
    _notes.remove(note);
    notifyListeners();
  }
}