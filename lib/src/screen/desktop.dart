import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:syncnote/src/section/notelist.dart';
import 'package:syncnote/src/section/noteview.dart';
import 'package:syncnote/src/section/sidebar.dart';

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  SidebarXController sidebarXController = SidebarXController(selectedIndex: 0);

  @override
  Widget build(BuildContext context) {
    sidebarXController.addListener(() => setState(() {}));
    final screenwidth = ScreenUtil().screenWidth;
    var normalSize = screenwidth / 20;
    var extendedSize = screenwidth / 8.5;

    return Row(
      children: [
        AnimatedContainer(
          width: sidebarXController.extended ? extendedSize : normalSize,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: SideBar(sidebarXController: sidebarXController),
        ),
        const Flexible(flex: 6, child: NoteList()),
        const Flexible(flex: 15, child: NoteView())
      ],
    );
  }
}
