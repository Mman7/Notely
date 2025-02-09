import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
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
    final isSelected = id == context.read<AppProvider>().noteSelected?.id;
    //TODO prevent title overtext
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(7.5)),
        color: isSelected ? Colors.white : Colors.white54,
        child: InkWell(
          hoverColor: Colors.white,
          onTap: () => context.read<AppProvider>().setNoteSelected(id: id),
          child: Stack(
            children: [
              if (bookmarked)
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.bookmark,
                    color: hexToColor('#964EC2'),
                  ),
                ),
              ListTile(
                title: Text(
                  title,
                  maxLines: 1,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : Colors.black54),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content,
                      maxLines: 2,
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
      ),
    );
  }
}
