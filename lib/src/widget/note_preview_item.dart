import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotePreviewItem extends StatelessWidget {
  const NotePreviewItem(
      {super.key,
      required this.date,
      required this.title,
      required this.content,
      required this.hadPreviewIMG});

  final String title;
  final String content;
  final DateTime date;
  final bool hadPreviewIMG;
  @override
  Widget build(BuildContext context) {
    //if hadPreviewIMG show pic else leave it blank
    //*tesing
    var pic = hadPreviewIMG
        ? Icon(Icons.ac_unit_rounded, color: Colors.red)
        : Icon(Icons.ac_unit_rounded, color: Colors.transparent);

    return ListTile(
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(content),
            Text(DateFormat('yyyy-MM-dd – kk:mm').format(date))
          ],
        ),
        //*testing
        trailing: pic
        // trailing: Image(),
        );
  }
}
