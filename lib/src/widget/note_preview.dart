import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/section/editor.dart';

class NotePreview extends StatelessWidget {
  const NotePreview({
    super.key,
    required this.index,
    required this.title,
    required this.content,
    required this.lastModified,
    required this.previewContent,
  });

  final int index;
  final String title;
  final String content;
  final String previewContent;
  final DateTime lastModified;

  String lastModifiedText() {
    List<String> date = lastModified.toLocal().toString().split('-');
    return '${date[0]}.${date[1]}.${date[2].split(' ')[0]}';
  }

  @override
  Widget build(BuildContext context) {
    List<Note> noteList = context.watch<AppProvider>().noteList;
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Editor(
            title: title,
            content: content,
            id: noteList[index].id,
            uuid: noteList[index].uuid,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              noteList[index].title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              noteList[index].previewContent,
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
