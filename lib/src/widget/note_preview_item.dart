import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';

class NotePreviewItem extends StatelessWidget {
  const NotePreviewItem(
      {super.key,
      required this.id,
      required this.date,
      required this.title,
      required this.content,
      required this.hadPreviewIMG});

  final int id;
  final String title;
  final String content;
  final DateTime date;
  final bool hadPreviewIMG;
  @override
  Widget build(BuildContext context) {
    //if hadPreviewIMG show pic else leave it blank
    //*tesing
    var pic = hadPreviewIMG
        ? const Icon(Icons.ac_unit_rounded, color: Colors.red)
        : const Icon(Icons.ac_unit_rounded, color: Colors.blue);

    return Material(
      color: Colors.teal,
      child: InkWell(
        onTap: () => context.read<AppProvider>().setNoteSelected(id: id),
        child: ListTile(
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
            ),
      ),
    );
  }
}
