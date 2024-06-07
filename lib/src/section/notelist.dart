import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/widget/note_preview_item.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key, required this.sidebarController});

  final SidebarXController sidebarController;
  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  TextEditingController searchController = TextEditingController();
  List searchItems = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AppProvider>().intializeData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List itemList = context.watch<AppProvider>().noteList;
    final searchMode = context.watch<AppProvider>().searchMode;

    searchController.addListener(() {
      final newSearchItem = itemList
          .where((element) => element.title.contains(searchController.text));

      setState(() {
        searchItems = newSearchItem.toList();
      });
    });

    return Container(
      color: hexToColor('EAF3FC'),
      child: Column(
        children: [
          searchMode
              ? SearchHeader(
                  searchController: searchController,
                  sidebarXController: widget.sidebarController,
                )
              : ListHeader(itemList: itemList),
          //list body
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(2),
              child: ListView.builder(
                  itemCount: searchController.text == ''
                      ? itemList.length
                      : searchItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Builder(builder: (context) {
                        if (searchController.text == '') {
                          return NotePreviewItem(
                              id: itemList[index].id,
                              date: itemList[index].dateCreated,
                              title: itemList[index].title,
                              content: itemList[index].previewContent,
                              hadPreviewIMG: itemList[index].includePic);
                        } else {
                          return NotePreviewItem(
                              id: searchItems[index].id,
                              date: searchItems[index].dateCreated,
                              title: searchItems[index].title,
                              content: searchItems[index].previewContent,
                              hadPreviewIMG: searchItems[index].includePic);
                        }
                      }),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class ListHeader extends StatelessWidget {
  const ListHeader({
    super.key,
    required this.itemList,
  });

  final List itemList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      margin: const EdgeInsets.only(bottom: 3.5),
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
    );
  }
}

class SearchHeader extends StatelessWidget {
  const SearchHeader(
      {super.key,
      required this.sidebarXController,
      required this.searchController});

  final TextEditingController searchController;
  final SidebarXController sidebarXController;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 15, 5),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  sidebarXController.selectIndex(3);
                  context.read<AppProvider>().setSearchMode(value: false);
                },
                icon: const Icon(Icons.arrow_back)),
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ));
  }
}
