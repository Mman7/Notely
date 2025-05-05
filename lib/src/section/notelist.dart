import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/model/mode_model.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/modules/local-database.dart';
import 'package:syncnote/src/widget/custom_popup_menuitem.dart';
import 'package:syncnote/src/widget/note_preview_item.dart';

class NoteList extends StatefulWidget {
  const NoteList({
    super.key,
  });

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
    final listmode = context.watch<AppProvider>().listMode;

    searchController.addListener(() {
      final newSearchItem = itemList
          .where((element) => element.title.contains(searchController.text));
      setState(() {
        searchItems = newSearchItem.toList();
      });
    });

    listModeSwitcher() {
      switch (listmode) {
        case Mode.noteBook:
          final notebook = context.watch<AppProvider>().noteBookSelected;
          final list = itemList
              .where((element) =>
                  element.notebook != null &&
                  element.notebook.contains(notebook?.title))
              .toList();

          return list;

        case Mode.bookmarks:
          var a = itemList
              .where(
                (element) => element.isBookmark == true,
              )
              .toList();

          return a;

        case Mode.search:
          if (searchController.text == '') return itemList;
          return searchItems;

        default:
          return itemList;
      }
    }

    return ClipRRect(
      child: Container(
        decoration: BoxDecoration(
          border: null,
          color: hexToColor('EAF3FC'),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: searchMode
                  ? SearchHeader(
                      searchController: searchController,
                    )
                  : ListHeader(
                      itemList: itemList,
                      list: listModeSwitcher(),
                    ),
            ),
            //list body
            Expanded(
              flex: 12,
              child: Container(
                padding: const EdgeInsets.all(2),
                child: ListView.builder(
                    itemCount: listModeSwitcher().length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        child: Builder(builder: (context) {
                          switch (listmode) {
                            case Mode.bookmarks:
                              final bookmarkedList = listModeSwitcher();
                              return NotePreviewItem(
                                id: bookmarkedList[index].id,
                                date: bookmarkedList[index].dateCreated,
                                title: bookmarkedList[index].title,
                                content: bookmarkedList[index].previewContent,
                                bookmarked: bookmarkedList[index].isBookmark,
                              );
                            case Mode.search:
                              if (searchController.text == '') {
                                return NotePreviewItem(
                                  id: itemList[index].id,
                                  date: itemList[index].dateCreated,
                                  title: itemList[index].title,
                                  content: itemList[index].previewContent,
                                  bookmarked: itemList[index].isBookmark,
                                );
                              }
                              return NotePreviewItem(
                                id: searchItems[index].id,
                                date: searchItems[index].dateCreated,
                                title: searchItems[index].title,
                                content: searchItems[index].previewContent,
                                bookmarked: searchItems[index].isBookmark,
                              );
                            default:
                              return NotePreviewItem(
                                id: itemList[index].id,
                                date: itemList[index].dateCreated,
                                title: itemList[index].title,
                                content: itemList[index].previewContent,
                                bookmarked: itemList[index].isBookmark,
                              );
                          }
                        }),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListHeader extends StatelessWidget {
  const ListHeader({
    super.key,
    required this.itemList,
    required this.list,
  });

  final List itemList;
  final List list;

  @override
  Widget build(BuildContext context) {
    final listMode = context.watch<AppProvider>().listMode;
    final noteBookSelected = context.watch<AppProvider>().noteBookSelected;

    final trailing = PopupMenuButton(
      icon: const Icon(
        Icons.more_vert,
      ),
      itemBuilder: (BuildContext context) => [
        CustomPopupMenuItem(
            icon: Icons.delete,
            onTap: () {
              Database().removeNoteBook(id: noteBookSelected?.id);
              context.read<AppProvider>().refreshNoteBook();
            },
            text: 'Delete Notebook'),
      ],
    );

    return Container(
        alignment: Alignment.center,
        decoration:
            BoxDecoration(color: Colors.white, border: null, boxShadow: [
          BoxShadow(
            color: hexToColor('42526E').withValues(alpha: 0.3),
            spreadRadius: 3,
            blurRadius: 25,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ]),
        child: ListTile(
            title: Text(
              listMode == Mode.noteBook && noteBookSelected != null
                  ? noteBookSelected.title
                  : listMode,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Total Notes ${list.length}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            trailing: noteBookSelected != null ? trailing : const Text('')));
  }
}

class SearchHeader extends StatelessWidget {
  const SearchHeader({super.key, required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 15, 5),
        color: Colors.white,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                context.read<AppProvider>().setSearchMode(value: false);
                context.read<AppProvider>().setListMode(value: Mode.allnotes);
              },
              icon: const Icon(Icons.arrow_back),
              style: ButtonStyle(
                  iconColor: WidgetStatePropertyAll(hexToColor('#50409A'))),
            ),
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search somethings here',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ));
  }
}
