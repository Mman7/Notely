import 'package:flutter/material.dart';
import 'package:syncnote/src/model/folder_model.dart';
import 'package:syncnote/src/section/note_list.dart';
import 'package:syncnote/src/widget/folder_widget.dart';

class FolderView extends StatelessWidget {
  const FolderView({
    super.key,
    required this.folder,
    this.id,
  });
  final FolderModel folder;
  final int? id;

  @override
  Widget build(BuildContext context) {
    folder.refreshNoteIncluded();
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NoteList(
                    folder: folder,
                  )),
        );
      },
      child: FolderWidget(
        folderTitle: folder.title,
        folderCount: folder.getNoteIncluded.length,
      ),
    );
  }
}
