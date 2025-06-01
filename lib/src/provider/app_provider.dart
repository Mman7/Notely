import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncnote/src/model/folder_model.dart';

import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/modules/local_database.dart';

class AppProvider extends ChangeNotifier {
  List<Note> noteList = [];
  List<FolderModel> folderList = [];
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
    final result = database.getAllNoteBook();
    folderList = result;
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
