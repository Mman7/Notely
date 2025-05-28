import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncnote/myobjectbox.dart';

import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/model/notebooks_model.dart';
import 'package:syncnote/src/modules/local_database.dart';

class AppProvider extends ChangeNotifier {
  final noteBox = objectbox.store.box<Note>();
  List<Note> noteList = [];
  List<Notebook> noteBooks = [];
  final database = Database();
  bool searchMode = false;
  String listMode = 'All Notes';
  bool isSidebarExtended = false;

  getDeviceType() {
    double screenWidth = ScreenUtil().screenWidth;
    if (screenWidth < 450) return DeviceType.mobile;
    if (screenWidth < 850) return DeviceType.tablet;
    if (screenWidth > 850) return DeviceType.windows;
    return DeviceType.mobile;
  }

  getAllNote() {
    final note = database.getAllNote();
    noteList = note;
  }

  getAllNoteBook() {
    final noteBookList = database.getAllNoteBook();
    noteBooks = noteBookList;
  }

  intializeData() {
    getAllNote();
    getAllNoteBook();
    notifyListeners();
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
