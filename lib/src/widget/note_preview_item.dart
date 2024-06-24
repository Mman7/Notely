import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';

class NotePreviewItem extends StatelessWidget {
  const NotePreviewItem({
    super.key,
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.bookmarked,
  });

  final int id;
  final String title;
  final String content;
  final DateTime date;
  final bool bookmarked;

  @override
  Widget build(BuildContext context) {
    var isSelected = id == context.read<AppProvider>().noteSelected?.id;

    //TODO preview pic function
    // var pic = hadPreviewIMG
    //     ? const Icon(Icons.ac_unit_rounded, color: Colors.red)
    //     : const Icon(Icons.ac_unit_rounded, color: Colors.blue);

    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(7.5)),
      color: isSelected ? Colors.white : Colors.white54,
      child: InkWell(
        hoverColor: Colors.white,
        onTap: () => context.read<AppProvider>().setNoteSelected(id: id),
        child: Stack(
          children: [
            if (bookmarked)
              const Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.bookmark,
                  color: Colors.red,
                ),
              ),
            ListTile(
              title: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.black : Colors.black54),
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
            ),
          ],
        ),
      ),
    );
  }
}
