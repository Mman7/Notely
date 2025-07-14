import 'package:flutter/material.dart';
import 'package:melonote/src/model/note_model.dart';
import 'package:melonote/src/section/editor.dart';
import 'package:melonote/src/section/folder_list_view.dart';
import 'package:melonote/src/section/note_list.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
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
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        currentIndex: 0, // Replace with your selected index logic
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Notes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_sharp), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.ios_share), label: 'Share'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) {
          //TODO implement navigation logic
          // Handle navigation here
          if (index == 0) {
            // Navigator.pushNamed(context, '/transfer');
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NoteList(
                        isSearching: true,
                      )),
            );
          }
          if (index == 2) {
            // Navigator.pushNamed(context, '/transfer');
          }
          if (index == 2) {
            // Navigator.pushNamed(context, '/settings');
          }
        },
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: SingleChildScrollView(
          child: Column(
            children: [FolderListView()],
          ),
        ),
      ),
    );
  }
}
