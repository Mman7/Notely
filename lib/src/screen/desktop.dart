import 'package:flutter/material.dart';
import 'package:melonote/src/provider/app_provider.dart';
import 'package:melonote/src/section/folder_list_view.dart';
import 'package:melonote/src/section/note_list.dart';
import 'package:melonote/src/section/settings_page.dart';
import 'package:melonote/src/section/sidebar.dart';
import 'package:melonote/src/section/transfer_page.dart';
import 'package:provider/provider.dart';

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  @override
  void initState() {
    super.initState();
  }

  List pages = [
    FolderListView(),
    NoteList(isSearching: true),
    TransferPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    int pageIndex = context.watch<AppProvider>().pageIndex;
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: SideBar(),
        ),
        Flexible(
            flex: 9,
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: pages[pageIndex],
            )),
      ],
    );
  }
}
