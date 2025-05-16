import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncnote/src/section/editor.dart';

class NotePreview extends StatelessWidget {
  const NotePreview({
    super.key,
    required this.index,
    required this.title,
    required this.previewText,
    required this.lastModified,
  });

  final int index;
  final String title;
  final String previewText;
  final DateTime lastModified;

  @override
  Widget build(BuildContext context) {
    String lastModifiedText() {
      List<String> date = lastModified.toLocal().toString().split('-');
      return '${date[0]}.${date[1]}.${date[2].split(' ')[0]}';
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Editor(
            title: title,
            content: previewText,
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
              'Title $index',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'This is a paragraph for note $index.',
              style: TextStyle(fontSize: 14.0),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            // fake date
            Text(
              lastModifiedText(),
              style: TextStyle(
                fontSize: 12.sp,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
