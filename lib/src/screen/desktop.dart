import 'package:flutter/material.dart';
import 'package:notely/src/provider/app_provider.dart';
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 3,
          child: SideBar(),
        ),
        Flexible(
            flex: 13,
            child: Container(
              // color: Theme.of(context).colorScheme.surface,
              child: pages[pageIndex],
            )),
      ],
    );
  }
}
