import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/modules/local-database.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/widget/custom_popup_menuitem.dart';
import 'package:toastification/toastification.dart';

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
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    Note note = Database().getNote(id: id);
                    return [
                      CustomPopupMenuItem(
                        text: note.isBookmark!
                            ? 'Remove from Bookmark'
                            : 'Add to Bookmark',
                        icon: Icons.menu_book_rounded,
                        onTap: () {
                          Database().toggleBookMarked(noteId: id);
                          context.read<AppProvider>().refresh();
                        },
                      ),
                      CustomPopupMenuItem(
                        text: 'Add to Notebook',
                        icon: Icons.menu_book,
                        onTap: () {
                          final noteBooks =
                              context.read<AppProvider>().noteBooks;
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 30, horizontal: 300),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  color: Colors.white,
                                  child: ListView.builder(
                                      itemCount: noteBooks.length,
                                      itemBuilder: (ctx, index) {
                                        return TextButton(
                                            onPressed: () {
                                              final noteBookTitle =
                                                  noteBooks[index].title;
                                              toastification.show(
                                                type:
                                                    ToastificationType.success,
                                                style:
                                                    ToastificationStyle.minimal,
                                                context:
                                                    context, // optional if you use ToastificationWrapper
                                                title: Text(
                                                    'Successfull add to $noteBookTitle'),
                                                autoCloseDuration:
                                                    const Duration(seconds: 3),
                                              );
                                              // prevent null
                                              if (note.notebook != null &&
                                                  note.notebook!.contains(
                                                      noteBookTitle)) {
                                                Navigator.of(context).pop();
                                                return;
                                              }

                                              if (note.notebook != null) {
                                                // if notebook had list add to list
                                                note.notebook
                                                    ?.add(noteBookTitle);
                                              } else {
                                                // else create a list
                                                note.notebook = [
                                                  noteBookTitle
                                                ];
                                              }
                                              Database().saveNote(note: note);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              noteBooks[index].title,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ));
                                      }),
                                );
                              });
                        },
                      ),
                      CustomPopupMenuItem(
                        text: 'Delete Note',
                        icon: Icons.menu_book_rounded,
                        onTap: () {
                          Database().removeNote(id: id);
                          context.read<AppProvider>().refresh();
                        },
                      ),
                    ];
                  },
                ),
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
