import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    //TODO: add smooth trasition when sidebar extended

    return Row(
      children: [
        Flexible(
            fit: FlexFit.tight,
            flex: sidebarXController.extended ? 3 : 1,
            child: SideBar(sidebarXController: sidebarXController)),
        const Flexible(flex: 6, child: NoteList()),
        const Flexible(flex: 15, child: NoteView())
      ],
    );
  }
}
