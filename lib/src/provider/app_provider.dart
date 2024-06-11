import 'package:flutter/material.dart';
import 'package:syncnote/myobjectbox.dart';
import 'package:syncnote/objectbox.g.dart';
import 'package:syncnote/src/model/note_model.dart';

class AppProvider extends ChangeNotifier {
  final noteBox = objectbox.store.box<Note>();
  List noteList = [];
  Note? noteSelected;
  bool searchMode = false;
  String listMode = 'allnotes';
  bool isSidebarExtended = false;

  changeSidebarExtended() {
    isSidebarExtended = !isSidebarExtended;
    notifyListeners();
  }

  setSearchMode({value}) {
    searchMode = value;
    notifyListeners();
  }

  /// get special data
  getSpData() {
    final query = noteBox.query(Note_.isBookmark.equals(true)).build();
    final data = query.find();

    print(data);
  }

  ///   value = [allnotes,bookmarks,notebooks or tags]
  setListMode({value}) {
    listMode = value;
    notifyListeners();
  }

  setNoteSelected({id}) {
    if (id == 0) {
      noteSelected = null;
      debugPrint('change [noteSelected] to null');
      notifyListeners();
      return;
    }

    var note = noteBox.get(id);
    noteSelected = note;
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
