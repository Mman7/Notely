import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:syncnote/myobjectbox.dart';
import 'package:syncnote/src/model/mode_model.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/model/notebooks_model.dart';
import 'package:syncnote/src/modules/local-database.dart';

class AppProvider extends ChangeNotifier {
  final noteBox = objectbox.store.box<Note>();
  List<Note> noteList = [];
  List<Notebook> noteBooks = [];
  final database = Database();
  Note? noteSelected;
  Notebook? noteBookSelected;
  bool searchMode = false;
  String listMode = 'All Notes';
  bool isSidebarExtended = false;

  setNoteBookSelect({required value}) {
    listMode = Mode.noteBook;
    final select = noteBooks.where((element) => element.title == value);
    noteBookSelected = select.first;
    notifyListeners();
  }

  clearNoteBookSelect() {
    noteBookSelected = null;
    notifyListeners();
  }

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

  /// value = [Mode]
  setListMode({required String value}) {
    listMode = value;

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
      final select = noteList.where((element) => element.id == id);
      noteSelected = select.first;
      inspect(select);
      notifyListeners();
    }
  }

  getAllNote() {
    final note = database.getAllNote();
    database.getSpecificNoteBook(id: 1);
    noteList = note;
  }

  intializeData() {
    getAllNote();
    getAllNoteBook();
    notifyListeners();
  }

  getAllNoteBook() {
    final noteBookList = database.getAllNoteBook();
    noteBooks = noteBookList;
  }

  refreshNoteBook() {
    getAllNoteBook();
    notifyListeners();
  }

  refresh() {
    intializeData();
    notifyListeners();
  }
}
