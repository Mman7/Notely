import 'dart:ui';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notely/src/modules/socket.dart';
import 'package:notely/src/provider/app_data.dart';
import 'package:provider/provider.dart';
import 'package:notely/myobjectbox.dart';
import 'package:notely/src/theme.dart';
import 'package:notely/src/provider/app_status.dart';
import 'package:notely/src/screen/desktop.dart';
import 'package:notely/src/screen/mobile.dart';
import 'package:notely/src/utils/myobjectbox.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io' show Platform;

//  flutter build apk --target-platform android-arm64
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  // if developing change it to false
  if (true) {
    if (Platform.isWindows) {
      await windowManager.ensureInitialized();
      WindowManager.instance.setMinimumSize(const Size(1200, 600));
    }
  }
  objectbox = await ObjectBox.create();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx) => AppStatus()),
      ChangeNotifierProvider(create: (ctx) => AppData())
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    context.read<AppStatus>().intializeData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSync = context.watch<AppStatus>().isSyncing;
    bool darkMode = context.watch<AppStatus>().isDarkMode;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isSync) {
        SocketClient.connect();
        SocketServer.startServer(callback: null);
      }
    });

    return ScreenUtilInit(
        minTextAdapt: true,
        builder: (ctx, child) {
          DeviceType deviceType = context.read<AppStatus>().getDeviceType();
          return ToastificationWrapper(
            child: MaterialApp(
              navigatorKey: navigatorKey,
              localizationsDelegates: const [
                FlutterQuillLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              scrollBehavior: MyCustomScrollBehavior(),
              themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
              theme: myTheme,
              darkTheme: myDarkTheme,
              home: DoubleTapToExit(
                child: Scaffold(
                  body: Container(
                    color: Colors.black,
                    child: Builder(
                      builder: (ctx) {
                        if (deviceType == DeviceType.mobile ||
                            deviceType == DeviceType.tablet) {
                          return ScreenUtilInit(
                              designSize: const Size(360, 1080),
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
            ),
          );
        });
  }
}
