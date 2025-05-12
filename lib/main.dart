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
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        minTextAdapt: true,
        builder: (ctx, child) {
          final screenwidth = ScreenUtil().screenWidth;
          DeviceType deviceTy =
              context.read<AppProvider>().getDeviceType(screenwidth);
          bool isMobileOrTable =
              deviceTy == DeviceType.mobile || deviceTy == DeviceType.tablet;

          debugPrint(screenwidth.toString());

          return ToastificationWrapper(
            child: MaterialApp(
              scrollBehavior: MyCustomScrollBehavior(),
              theme: myTheme,
              home: Scaffold(
                floatingActionButtonLocation: isMobileOrTable
                    ? FloatingActionButtonLocation.centerDocked
                    : null,
                floatingActionButton: isMobileOrTable
                    ? FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () {},
                      )
                    : null,
                bottomNavigationBar: isMobileOrTable
                    ? BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        showSelectedLabels: false,
                        currentIndex: _selectedIndex,
                        onTap: _onItemTapped,
                        items: const [
                          BottomNavigationBarItem(
                              icon: Icon(Icons.book), label: 'Notes'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.search_sharp), label: 'Search'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.ios_share), label: 'Share'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.settings), label: 'Settings'),
                        ],
                      )
                    : null,
                body: Container(
                  color: Colors.black,
                  child: Builder(
                    builder: (ctx) {
                      DeviceType deviceType = context
                          .read<AppProvider>()
                          .getDeviceType(screenwidth);

                      if (deviceType == DeviceType.mobile) {
                        return ScreenUtilInit(
                            designSize: const Size(360, 1080),
                            builder: (ctx, child) {
                              return const MobileLayout();
                            });
                      }
                      if (deviceType == DeviceType.tablet) {
                        return ScreenUtilInit(
                            designSize: const Size(500, 1080),
                            builder: (ctx, child) {
                              return const MobileLayout();
                            });
                      }
                      if (deviceType == DeviceType.windows) {
                        return ScreenUtilInit(
                            designSize: const Size(1200, 1080),
                            builder: (ctx, child) {
                              return const DesktopLayout();
                            });
                      }
                      return const SizedBox
                          .shrink(); // Default return statement
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }
}
