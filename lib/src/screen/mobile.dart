import 'package:flutter/material.dart';
import 'package:syncnote/src/section/folder_list_view.dart';
import 'package:syncnote/src/section/note_list.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to NoteList page (triggered by user interaction)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NoteList()),
      );
    });
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Column(
          children: [FolderListView()],
        ),
      ),
    );
  }
}
