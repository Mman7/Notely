import 'package:flutter/material.dart';
import 'package:melonote/src/model/note_model.dart';
import 'package:melonote/src/provider/app_provider.dart';
import 'package:melonote/src/section/editor.dart';
import 'package:melonote/src/section/folder_list_view.dart';
import 'package:melonote/src/section/note_list.dart';
import 'package:melonote/src/section/settings_page.dart';
import 'package:melonote/src/section/transfer_page.dart';
import 'package:provider/provider.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  int _selectedIndex = 0;
  List pages = [
    FolderListView(),
    NoteList(
      isSearching: true,
    ),
    TransferPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    int pageIndex = context.watch<AppProvider>().pageIndex;
    if (_selectedIndex != pageIndex) setState(() => _selectedIndex = pageIndex);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withBlue(255).withAlpha(200),
            spreadRadius: 1,
            blurRadius: 30,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ]),
        child: Builder(
          builder: (ctx) => FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (context) => Editor(
                    note: Note.newNote(),
                    isNew: true,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Notes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_sharp), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.ios_share), label: 'Share'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) {
          context.read<AppProvider>().setPageIndex(index);
        },
      ),
      body: pages[pageIndex],
    );
  }
}
