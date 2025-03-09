import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/theme.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/screen/desktop.dart';
import 'package:syncnote/src/screen/mobile.dart';
import 'package:syncnote/src/utils/myobjectbox.dart';
import 'package:toastification/toastification.dart';
import 'myobjectbox.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods like buildOverscrollIndicator and buildScrollbar
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
////* MAIN TODO
////  1 phone version try tcp transfer data
////  2 phone style
////  3
////
////

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();
  runApp(ChangeNotifierProvider(
    create: (ctx) => AppProvider(),
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 1080),
        minTextAdapt: true,
        builder: (ctx, child) {
          final screenwidth = ScreenUtil().screenWidth;
          var isMobile = screenwidth < 800;
          debugPrint(screenwidth.toString());

          return ToastificationWrapper(
            child: MaterialApp(
              scrollBehavior: MyCustomScrollBehavior(),
              theme: myTheme,
              home: Scaffold(
                //TODO add drawer for mobile

                body: Container(
                  color: Colors.black,
                  child: Builder(
                    builder: (ctx) {
                      if (isMobile)
                        return const MobileLayout();
                      else
                        return const DesktopLayout();
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }
}
