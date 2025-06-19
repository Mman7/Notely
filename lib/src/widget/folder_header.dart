import 'package:flutter/material.dart';
import 'package:melonote/src/section/note_list.dart';
import 'package:melonote/src/widget/folder_widget.dart';

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
