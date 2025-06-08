import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncnote/src/model/folder_model.dart';

import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/modules/local_database.dart';

class AppProvider extends ChangeNotifier {
  List<Note> noteList = [];
  List<FolderModel> folderList = [];
  final database = Database();

  getDeviceType() {
    double screenWidth = ScreenUtil().screenWidth;
    if (screenWidth < 450) return DeviceType.mobile;
    if (screenWidth < 850) return DeviceType.tablet;
    if (screenWidth > 850) return DeviceType.windows;
    return DeviceType.mobile;
  }

  intializeNote() {
    final note = database.getAllNote();
    noteList = note;
  }

  intializeFolder() {
    final result = database.getAllFolder();
    folderList = result;
  }

  intializeData() {
    intializeNote();
    intializeFolder();
    notifyListeners();
  }

  refreshNoteBook() {
    intializeFolder();
    notifyListeners();
  }

  refresh() {
    intializeData();
    notifyListeners();
  }
}
