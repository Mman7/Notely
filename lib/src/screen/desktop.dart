import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/section/notelist.dart';
import 'package:syncnote/src/section/noteview.dart';
import 'package:syncnote/src/section/sidebar.dart';

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  @override
  Widget build(BuildContext context) {
    var isExtended = context.watch<AppProvider>().isSidebarExtended;
    final screenwidth = ScreenUtil().screenWidth;
    var normalSize = screenwidth / 20;
    var extendedSize = screenwidth / 8.5;

    return Row(
      children: [
        AnimatedContainer(
          width: isExtended ? extendedSize : normalSize,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: const SideBar(),
        ),
        Flexible(flex: 6, child: NoteList()),
        const Flexible(flex: 15, child: NoteView())
      ],
    );
  }
}
