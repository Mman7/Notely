import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:syncnote/myobjectbox.dart';
import 'package:syncnote/objectbox.g.dart';
import 'package:syncnote/src/model/mode_model.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/model/notebooks_model.dart';

class AppProvider extends ChangeNotifier {
  final noteBox = objectbox.store.box<Note>();
  final noteBook = [];
  List<Note> noteList = [];
  List<Notebook> noteBooks = [];
  Note? noteSelected;
  bool searchMode = false;
  String listMode = 'allnotes';
  bool isSidebarExtended = false;

  changeSidebarExtended({value}) {
    if (value != null) {
      isSidebarExtended = value;
    } else {
      isSidebarExtended = !isSidebarExtended;
    }
    notifyListeners();
  }

  setSearchMode({value}) {
    searchMode = value;
    notifyListeners();
  }

  /// value = [Mode.bookmarks / Mode.notebooks / Mode.tags]
  setListMode({required String value}) {
    listMode = value;
    var data = getSpData(mode: value);
    noteList = data;
    notifyListeners();
  }

  setNoteSelected({id}) {
    // for Add New Note function
    if (id == 0) {
      noteSelected = null;
      debugPrint('change [noteSelected] to null');
      notifyListeners();
      return;
    } else {
      var note = noteBox.get(id);
      noteSelected = note;
      notifyListeners();
    }
  }

  getAllNote() {
    var notes = noteBox.getAll();
    noteList = notes;
    inspect(notes);
  }

  intializeData() {
    getAllNote();
    notifyListeners();
  }

  refresh() {
    intializeData();
    notifyListeners();
  }

  /// get special data
  /// mode = [Mode.bookmarks / Mode.notebooks / Mode.tags]
  getSpData({required String mode}) {
    switch (mode) {
      case Mode.bookmarks:
        final query = noteBox.query(Note_.isBookmark.equals(true)).build();
        final data = query.find();
        return data;

      //TODO implement these two
      case Mode.notebook:
        break;

      case Mode.tags:
        return noteBox.getAll();

      default:
        return noteBox.getAll();
    }
  }
}
