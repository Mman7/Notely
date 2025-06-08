import 'package:flutter/material.dart';
import 'package:syncnote/src/section/note_list.dart';
import 'package:syncnote/src/widget/folder_widget.dart';

class FolderHeader extends StatelessWidget {
  const FolderHeader({super.key, required this.listCount});
  final int listCount;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoteList()),
        );
      },
      child: FolderWidget(folderTitle: 'All notes', folderCount: listCount),
    );
  }
}
