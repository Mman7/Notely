import 'package:flutter/material.dart';
import 'package:melonote/src/model/folder_model.dart';
import 'package:melonote/src/section/note_list.dart';
import 'package:melonote/src/widget/folder_widget.dart';

class FolderView extends StatelessWidget {
  const FolderView({
    super.key,
    required this.folder,
  });
  final FolderModel folder;

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
