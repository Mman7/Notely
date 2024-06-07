import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';

//TODO hold press drop down menu

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
    var isSelected = id == context.read<AppProvider>().noteSelected?.id;

    //TODO preview pic function
    //if hadPreviewIMG show pic else leave it blank
    //*tesing
    var pic = hadPreviewIMG
        ? const Icon(Icons.ac_unit_rounded, color: Colors.red)
        : const Icon(Icons.ac_unit_rounded, color: Colors.blue);

    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(7.5)),
      color: isSelected ? Colors.white : Colors.white60,
      // color: Colors.white,
      child: InkWell(
        hoverColor: Colors.white,
        onTap: () => context.read<AppProvider>().setNoteSelected(id: id),
        child: ListTile(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: const TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w400),
                ),
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
