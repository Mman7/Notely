import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/widget/note_preview_item.dart';

class NoteList extends StatefulWidget {
  const NoteList({
    super.key,
  });

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AppProvider>().intializeData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final itemList = context.watch<AppProvider>().noteList;

    return Container(
      color: Colors.red,
      child: Column(
        children: [
          const Text('Note List Section'),
          Expanded(
            child: Container(
              color: Colors.lime,
              child: ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    return NotePreviewItem(
                        id: itemList[index].id,
                        date: itemList[index].dateCreated,
                        title: itemList[index].title,
                        content: itemList[index].previewContent,
                        hadPreviewIMG: itemList[index].includePic);
                  }),
              // itemBuilder: (context, index) => Text(demo_data[index].data),
            ),
          ),
        ],
      ),
    );
  }
}
