import 'package:flutter/material.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/section/editor.dart';

class NotePreview extends StatelessWidget {
  const NotePreview({
    super.key,
    required this.index,
    required this.note,
  });

  final Note note;
  final int index;

  String lastModifiedText() {
    if (note.lastestModified == null) return '';
    List<String> date = note.lastestModified!.toLocal().toString().split('-');
    return '${date[0]}.${date[1]}.${date[2].split(' ')[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Editor(
            note: note,
            isNew: false,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              note.previewContent,
              style: TextStyle(fontSize: 14.0),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Text(
              lastModifiedText(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
