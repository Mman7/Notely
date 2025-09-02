import 'package:flutter/material.dart';
import 'package:notely/src/section/note_list.dart';
import 'package:notely/src/widget/folder_widget.dart';

class FolderHeader extends StatefulWidget {
  const FolderHeader({super.key, required this.listCount});
  final int listCount;

  @override
  State<FolderHeader> createState() => _FolderHeaderState();
}

class _FolderHeaderState extends State<FolderHeader> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onHover: (value) => setState(() => isHover = value),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteList()),
          );
        },
        child: FolderWidget(
            folderTitle: 'All notes', folderCount: widget.listCount));
  }
}
