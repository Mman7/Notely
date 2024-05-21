import 'package:flutter/material.dart';
import 'package:syncnote/src/widget/note_preview_item.dart';
import '../demo_data.dart';

class NoteList extends StatelessWidget {
  NoteList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        children: [
          Text('Note List Section'),
          Expanded(
            child: Container(
              color: Colors.lime,
              child: ListView.builder(
                  itemCount: demo_data.length,
                  itemBuilder: (context, index) {
                    var item = demo_data[index];

                    return NotePreviewItem(
                        date: item.timeCreated,
                        title: item.title,
                        content: item.data,
                        hadPreviewIMG: item.hadPreviewIMG);
                  }),
              // itemBuilder: (context, index) => Text(demo_data[index].data),
            ),
          ),
        ],
      ),
    );
  }
}
