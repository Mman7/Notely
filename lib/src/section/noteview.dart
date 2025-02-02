import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/myobjectbox.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/modules/local-database.dart';
import 'package:syncnote/src/widget/custom_popup_menuitem.dart';
import 'package:uuid/uuid.dart';

//TODO mobile if user editing show bottom sticky TOOLBAR
//TODO finish tool bar style

class NoteView extends StatefulWidget {
  const NoteView({
    super.key,
  });

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final QuillController _controller = QuillController.basic();
  final titleController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Note? note = context.watch<AppProvider>().noteSelected;

    if (note != null) {
      // set title
      titleController.text = note.title!;
      // set content
      var rawData = jsonDecode(note.content!);
      _controller.document = Document.fromJson(rawData);

      debugPrint('note selected ${note.id.toString()}');
    }

    if (note == null) {
      // clean content and title
      titleController.clear();
      _controller.clear();
    }
    return Container(
      color: Colors.green,
      child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                color: Colors.red,
                child: QuillToolbar(
                    configurations: const QuillToolbarConfigurations(
                      sharedConfigurations: QuillSharedConfigurations(
                        locale: Locale('en'),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              QuillToolbarHistoryButton(
                                isUndo: true,
                                controller: _controller,
                              ),
                              QuillToolbarHistoryButton(
                                isUndo: false,
                                controller: _controller,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () => saveData(note),
                                  icon: const Icon(Icons.check)),
                              IgnorePointer(
                                ignoring: note == null,
                                child: PopupMenuButton(
                                  icon: const Icon(
                                    Icons.more_vert,
                                  ),
                                  itemBuilder: (BuildContext context) => [
                                    if (note != null)
                                      CustomPopupMenuItem(
                                          icon: Icons.delete,
                                          onTap: () => deleteNote(id: note.id),
                                          text: 'Delete Note'),
                                    if (note?.isBookmark == true)
                                      CustomPopupMenuItem(
                                          icon: Icons.bookmark_add,
                                          onTap: () => unsetBookmarked(),
                                          text: 'Remove from Bookmarked'),
                                    if (note?.isBookmark == false)
                                      CustomPopupMenuItem(
                                          icon: Icons.bookmark_add,
                                          onTap: () =>
                                              setBookmarked(note: note),
                                          text: 'Add to Bookmark'),
                                    CustomPopupMenuItem(
                                        icon: Icons.menu_book,
                                        onTap: () =>
                                            showNoteBookOptions(context, note),
                                        text: 'Add to Notebook'),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              )),
          //TODO row 2 tool bar custom
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: Colors.yellow,
              child: QuillToolbar(
                configurations: QuillToolbarConfigurations(
                  sharedConfigurations: const QuillSharedConfigurations(
                    locale: Locale('en'),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      QuillToolbarFontFamilyButton(controller: _controller),
                      QuillToolbarFontSizeButton(controller: _controller),
                      QuillToolbarSelectHeaderStyleDropdownButton(
                          controller: _controller),
                      QuillToolbarToggleStyleButton(
                        options: const QuillToolbarToggleStyleButtonOptions(),
                        controller: _controller,
                        attribute: Attribute.bold,
                      ),
                      QuillToolbarToggleStyleButton(
                        options: const QuillToolbarToggleStyleButtonOptions(),
                        controller: _controller,
                        attribute: Attribute.italic,
                      ),
                      QuillToolbarToggleStyleButton(
                        controller: _controller,
                        attribute: Attribute.underline,
                      ),
                      QuillToolbarClearFormatButton(
                        controller: _controller,
                      ),
                      const VerticalDivider(
                        endIndent: 10,
                        indent: 10,
                      ),
                      QuillToolbarColorButton(
                        controller: _controller,
                        isBackground: false,
                      ),
                      QuillToolbarColorButton(
                        controller: _controller,
                        isBackground: true,
                      ),
                      const VerticalDivider(
                        endIndent: 10,
                        indent: 10,
                      ),
                      QuillToolbarToggleCheckListButton(
                        controller: _controller,
                      ),
                      QuillToolbarToggleStyleButton(
                        controller: _controller,
                        attribute: Attribute.ol,
                      ),
                      QuillToolbarToggleStyleButton(
                        controller: _controller,
                        attribute: Attribute.ul,
                      ),
                      QuillToolbarToggleStyleButton(
                        controller: _controller,
                        attribute: Attribute.inlineCode,
                      ),
                      const VerticalDivider(
                        endIndent: 10,
                        indent: 10,
                      ),
                      QuillToolbarToggleStyleButton(
                        controller: _controller,
                        attribute: Attribute.blockQuote,
                      ),
                      QuillToolbarIndentButton(
                        controller: _controller,
                        isIncrease: true,
                      ),
                      QuillToolbarIndentButton(
                        controller: _controller,
                        isIncrease: false,
                      ),
                      const VerticalDivider(
                        endIndent: 10,
                        indent: 10,
                      ),
                      QuillToolbarLinkStyleButton(controller: _controller),
                      QuillToolbarSearchButton(controller: _controller),
                      // QuillToolbar
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 25,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(fontSize: 25),
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      hintText: 'New Note',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: QuillEditor.basic(
                      configurations: QuillEditorConfigurations(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        controller: _controller,
                        sharedConfigurations: const QuillSharedConfigurations(
                          locale: Locale('en'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // add this to tag
  Future<dynamic> showNoteBookOptions(BuildContext context, Note? note) {
    return showDialog(
        context: context,
        builder: (ctx) {
          final noteBooks = context.read<AppProvider>().noteBooks;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 300),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 57, 35, 35),
                borderRadius: BorderRadius.circular(20)),
            child: ListView.builder(
                itemCount: noteBooks.length,
                itemBuilder: (ctx, index) {
                  return TextButton(
                      onPressed: () {
                        final noteBookTitle = noteBooks[index].title;

                        // prevent null
                        if (note?.notebook != null &&
                            note!.notebook!.contains(noteBookTitle)) {
                          Navigator.of(context).pop();
                          return;
                        }

                        if (note?.notebook != null) {
                          // if notebook had list add to list
                          note?.notebook?.add(noteBookTitle);
                        } else {
                          // else create a list
                          note?.notebook = [noteBookTitle];
                        }

                        if (note == null) return;
                        Database().saveNote(note: note);
                        Navigator.of(context).pop();
                        //TODO add toast
                      },
                      child: Text(noteBooks[index].title));
                }),
          );
        });
  }

  void setBookmarked({required Note? note}) {
    if (note == null) return;
    note.isBookmark = true;
    Database().saveNote(note: note);
    context.read<AppProvider>().refresh();
    debugPrint('bookmarked');
  }

  unsetBookmarked() {
    var noteSelected = context.read<AppProvider>().noteSelected;
    if (noteSelected == null) return;

    final noteBox = objectbox.store.box<Note>();

    noteSelected.isBookmark = false;

    //Update Data
    noteBox.put(noteSelected);
    context.read<AppProvider>().refresh();
    debugPrint('unBookmarked');
  }

  void deleteNote({required id}) {
    Database().removeNote(id: id);
    context.read<AppProvider>().refresh();
  }

  String shortPlainText(String text) {
    final splitText = text.split('\n');
    final firstParagraph = splitText[0];
    if (firstParagraph.length < 60) {
      return '$firstParagraph \n';
    } else {
      return '${firstParagraph.substring(0, 60)}...\n';
    }
  }

  void saveData(Note? note) {
    final plainText = _controller.document.toPlainText();
    // prevent null content
    if (plainText[0] == '\n' && titleController.text == '') return;

    final data = _controller.document.toDelta();
    final jsonData = jsonEncode(data);

    Note updateNote = Note(
        id: note != null ? note.id : 0,
        previewContent: shortPlainText(plainText),
        uuid: note != null ? note.uuid : const Uuid().v4(),
        title: titleController.text,
        content: jsonData,
        dateCreated: DateTime.now());
    Database().saveNote(note: updateNote);

    // refresh current editing note
    context.read<AppProvider>().refresh();
    final lastestNote = context.read<AppProvider>().noteList.last;
    context.read<AppProvider>().setNoteSelected(id: note?.id ?? lastestNote.id);
    return;
  }
}
