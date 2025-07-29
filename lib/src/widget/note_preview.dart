import 'package:flutter/material.dart';
import 'package:melonote/src/model/note_model.dart';
import 'package:melonote/src/section/editor.dart';

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
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(85, 158, 158, 158),
              offset: Offset(0, 0),
              spreadRadius: 1,
              blurRadius: 20,
            ),
          ],
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.surfaceBright,
                Theme.of(context).colorScheme.primary
              ]),
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
                fontSize: 20.0,
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              note.previewContent,
              style: TextStyle(
                  fontSize: 14.0,
                  color: Theme.of(context).colorScheme.surface.withAlpha(225),
                  fontWeight: FontWeight.w500),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Text(
              lastModifiedText(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
