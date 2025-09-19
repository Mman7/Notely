import 'package:notely/src/model/folder_model.dart';
import 'package:notely/src/model/note_model.dart';
import 'package:flutter/material.dart';
import 'package:notely/src/modules/local_database.dart';

class AppData extends ChangeNotifier {
  List<Note> noteList = [];
  List<FolderModel> folderList = [];

  /// intialize or refresh notes
  void intializeNote() {
    noteList = Database.getAllNote();
    notifyListeners();
  }

  /// intialize or refresh folders
  void intializeFolder() {
    folderList = Database.getAllFolder();
    notifyListeners();
  }

  void intializeData() {
    intializeNote();
    intializeFolder();
    notifyListeners();
  }

  void refreshAll() {
    intializeData();
  }
}
