import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/widget/note_preview_item.dart';

//TODO implement function with sidebar

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
      color: hexToColor('EAF3FC'),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: hexToColor('42526E').withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 30,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ]),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'All notes',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Total Notes ${itemList.length}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ))
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(2),
              child: ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: NotePreviewItem(
                          id: itemList[index].id,
                          date: itemList[index].dateCreated,
                          title: itemList[index].title,
                          content: itemList[index].previewContent,
                          hadPreviewIMG: itemList[index].includePic),
                    );
                  }),
              // itemBuilder: (context, index) => Text(demo_data[index].data),
            ),
          ),
        ],
      ),
    );
  }
}
