import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notely/src/model/folder_model.dart';
import 'package:notely/src/model/note_model.dart';
import 'package:notely/src/modules/local_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  List<Note> noteList = [];
  List<FolderModel> folderList = [];
  int pageIndex = 0;
  Database database = Database();
  bool isDarkMode = false;

  setPageIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }

  darkModeToggle() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode = !isDarkMode;
    prefs.setBool('darkmode', isDarkMode);
    notifyListeners();
  }

  getDeviceType() {
    double screenWidth = ScreenUtil().screenWidth;
    if (screenWidth < 450) return DeviceType.mobile;
    if (screenWidth < 900) return DeviceType.tablet;
    if (screenWidth > 900) return DeviceType.windows;
    return DeviceType.mobile;
  }

  intializeNote() {
    final note = database.getAllNote();
    noteList = note;
    notifyListeners();
  }

  intializeFolder() {
    final result = database.getAllFolder();
    folderList = result;
  }

  intializeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? darkmode = prefs.getBool('darkmode') ?? false;
    isDarkMode = darkmode;
    intializeNote();
    intializeFolder();
    notifyListeners();
  }

  refreshNote() {
    intializeNote();
  }

  refreshFolder() {
    intializeFolder();
    notifyListeners();
  }

  refreshAll() {
    intializeData();
    notifyListeners();
  }
}
