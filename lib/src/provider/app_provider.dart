import 'package:flutter/material.dart';
import 'package:syncnote/myobjectbox.dart';
import 'package:syncnote/src/model/note_model.dart';

class AppProvider extends ChangeNotifier {
  final noteBox = objectbox.store.box<Note>();
  List noteList = [];
  Note? noteSelected;

  setNoteSelected({id}) {
    if (id == 0) {
      noteSelected = null;
      debugPrint('change [noteSelected] to null');
      notifyListeners();
      return;
    }

    var note = noteBox.get(id);
    noteSelected = note;

    debugPrint(noteSelected.toString());
    debugPrint(noteSelected?.content);
    debugPrint(noteSelected?.title);
    notifyListeners();
  }

  intializeData() {
    var data = noteBox.getAll();
    noteList = data;
    notifyListeners();
  }

  refresh() {
    intializeData();
    notifyListeners();
  }
}
