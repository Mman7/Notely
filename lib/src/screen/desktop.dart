import 'package:flutter/material.dart';
import 'package:notely/src/provider/app_status.dart';
import 'package:notely/src/section/folder_list_view.dart';
import 'package:notely/src/section/note_list.dart';
import 'package:notely/src/section/settings_page.dart';
import 'package:notely/src/section/sidebar.dart';
import 'package:notely/src/section/transfer_page.dart';
import 'package:provider/provider.dart';

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  List pages = [
    FolderListView(),
    NoteList(isSearching: true),
    TransferPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    int pageIndex = context.watch<AppStatus>().pageIndex;
    return Container(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 3,
            child: SideBar(),
          ),
          Expanded(flex: 13, child: pages[pageIndex]),
        ],
      ),
    );
  }
}
