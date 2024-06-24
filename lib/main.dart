import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/screen/desktop.dart';
import 'package:syncnote/src/screen/mobile.dart';
import 'package:syncnote/src/utils/myobjectbox.dart';
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
          var isMobile = screenwidth < 490;
          var isDesktop = screenwidth > 1080;
          debugPrint(screenwidth.toString());

          return MaterialApp(
            scrollBehavior: MyCustomScrollBehavior(),
            home: Scaffold(
              //TODO add drawer for mobile
              // drawer: SideBar(
              //   sidebarXController: sidebarXController,
              // ),
              body: Container(
                color: Colors.black,
                child: Builder(
                  builder: (ctx) {
                    if (isMobile) return const MobileLayout();
                    if (isDesktop) return const DesktopLayout();
                    return Container();
                  },
                ),
              ),
            ),
          );
        });
  }
}
