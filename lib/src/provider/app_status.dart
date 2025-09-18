import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStatus extends ChangeNotifier {
  int pageIndex = 0;
  bool isDarkMode = false;
  bool isSyncing = false;

  toggleIsSyncing() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isSyncing = !isSyncing;
    prefs.setBool('issyncing', isSyncing);
    notifyListeners();
  }

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

  intializeStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? darkmode = prefs.getBool('darkmode') ?? false;
    isDarkMode = darkmode;
    bool? syncing = prefs.getBool('issyncing') ?? false;
    isSyncing = syncing;
    notifyListeners();
  }
}
