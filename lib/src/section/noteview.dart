import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/modules/local-database.dart';
import 'package:syncnote/src/widget/custom_popup_menuitem.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

//TODO mobile if user editing show bottom sticky TOOLBAR

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
  final scrollController = ScrollController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    titleController.dispose();
    super.dispose();
  }

  void clearUndoRedoHistory() {
    // Reset the controller's document to a new empty document or a default content
    _controller.document = Document.fromJson([
      {"insert": "\n"},
    ]);
    setState(() {}); // Trigger UI update
  }

  void getData() {
    Note? note = context.read<AppProvider>().noteSelected;
    if (note != null) {
      setState(() {
        // set Title
        titleController.text = note.title!;
        // set content
        final rawData = jsonDecode(note.content!);
        _controller.document = Document.fromJson(rawData);
      });

      debugPrint('note selected ${note.id.toString()}');
    }

    if (note == null) {
      // clean content and title
      clearUndoRedoHistory();
      titleController.clear();
      _controller.clear();
    }
  }

  @override
  void didChangeDependencies() {
    getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Note? note = context.watch<AppProvider>().noteSelected;
    final firstToolbarBtnClr = Colors.white;
    final secondToolbarBtnClr = Colors.black;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
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
                              Tooltip(
                                message: 'Undo',
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      if (_controller.hasUndo) {
                                        _controller.undo();
                                      }
                                    },
                                    icon: Icon(Icons.keyboard_arrow_left)),
                              ),
                              Tooltip(
                                message: 'Redo',
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      if (_controller.hasRedo) {
                                        _controller.redo();
                                      }
                                    },
                                    icon: Icon(Icons.keyboard_arrow_right)),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  color: firstToolbarBtnClr,
                                  onPressed: () => saveData(note),
                                  icon: const Icon(Icons.check)),
                              IgnorePointer(
                                ignoring: note == null,
                                child: PopupMenuButton(
                                  iconColor: firstToolbarBtnClr,
                                  icon: const Icon(
                                    Icons.more_vert,
                                  ),
                                  itemBuilder: (BuildContext context) => [
                                    if (note != null)
                                      CustomPopupMenuItem(
                                          icon: Icons.bookmark_add,
                                          onTap: () {
                                            Database().toggleBookMarked(
                                                noteId: note.id);
                                            context
                                                .read<AppProvider>()
                                                .refresh();
                                          },
                                          text: 'Add to Bookmarked'),
                                    CustomPopupMenuItem(
                                        icon: Icons.menu_book,
                                        onTap: () =>
                                            showNoteBookOptions(context, note),
                                        text: 'Add to Notebook'),
                                    if (note != null)
                                      CustomPopupMenuItem(
                                          icon: Icons.delete,
                                          onTap: () => Database()
                                              .removeNote(id: note.id),
                                          text: 'Delete Note'),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              )),
          Expanded(
            flex: 2,
            child: SizedBox(
              width: double.infinity,
              child: QuillToolbar(
                configurations: QuillToolbarConfigurations(
                  sharedConfigurations: QuillSharedConfigurations(
                    locale: Locale('en'),
                  ),
                ),
                child: Listener(
                    onPointerSignal: (event) {
                      if (event is PointerScrollEvent) {
                        final scrollDireation = event.scrollDelta.dy;
                        final offset = scrollController.offset;
                        final positionPixel = scrollController.position.pixels;

                        final maxScrollExtent =
                            scrollController.position.maxScrollExtent;
                        final minScrollExtent =
                            scrollController.position.minScrollExtent;

                        if (scrollDireation > 0) {
                          if (offset >= maxScrollExtent) return;
                          scrollController.jumpTo(positionPixel + 20);
                        } else {
                          if (offset <= minScrollExtent) return;
                          scrollController.jumpTo(positionPixel - 20);
                        }
                      }
                    },
                    child: SingleChildScrollView(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          QuillToolbarFontFamilyButton(controller: _controller),
                          QuillToolbarFontSizeButton(controller: _controller),
                          QuillToolbarSelectHeaderStyleDropdownButton(
                              controller: _controller),
                          QuillToolbarToggleStyleButton(
                            options: QuillToolbarToggleStyleButtonOptions(
                                iconTheme: QuillIconTheme(
                                    iconButtonUnselectedData: IconButtonData(
                                        color: secondToolbarBtnClr))),
                            controller: _controller,
                            attribute: Attribute.bold,
                          ),
                          QuillToolbarToggleStyleButton(
                            options: QuillToolbarToggleStyleButtonOptions(
                                iconTheme: QuillIconTheme(
                                    iconButtonUnselectedData: IconButtonData(
                                        color: secondToolbarBtnClr))),
                            controller: _controller,
                            attribute: Attribute.italic,
                          ),
                          QuillToolbarToggleStyleButton(
                            options: QuillToolbarToggleStyleButtonOptions(
                                iconTheme: QuillIconTheme(
                                    iconButtonUnselectedData: IconButtonData(
                                        color: secondToolbarBtnClr))),
                            controller: _controller,
                            attribute: Attribute.underline,
                          ),
                          QuillToolbarClearFormatButton(
                            options: QuillToolbarToggleStyleButtonOptions(
                                iconTheme: QuillIconTheme(
                                    iconButtonUnselectedData: IconButtonData(
                                        color: secondToolbarBtnClr))),
                            controller: _controller,
                          ),
                          VerticalDivider(
                            endIndent: 10,
                            indent: 10,
                          ),
                          QuillToolbarColorButton(
                            options: QuillToolbarColorButtonOptions(
                                iconTheme: QuillIconTheme(
                                    iconButtonUnselectedData: IconButtonData(
                                        color: secondToolbarBtnClr))),
                            controller: _controller,
                            isBackground: false,
                          ),
                          QuillToolbarColorButton(
                            options: QuillToolbarColorButtonOptions(
                                iconTheme: QuillIconTheme(
                                    iconButtonUnselectedData: IconButtonData(
                                        color: secondToolbarBtnClr))),
                            controller: _controller,
                            isBackground: true,
                          ),
                          VerticalDivider(
                            endIndent: 10,
                            indent: 10,
                          ),
                          QuillToolbarToggleCheckListButton(
                            options: QuillToolbarToggleCheckListButtonOptions(
                                iconTheme: QuillIconTheme(
                                    iconButtonUnselectedData: IconButtonData(
                                        color: secondToolbarBtnClr))),
                            controller: _controller,
                          ),
                          QuillToolbarToggleStyleButton(
                            options: QuillToolbarToggleStyleButtonOptions(
                                iconTheme: QuillIconTheme(
                                    iconButtonUnselectedData: IconButtonData(
                                        color: secondToolbarBtnClr))),
                            controller: _controller,
                            attribute: Attribute.ol,
                          ),
                          QuillToolbarToggleStyleButton(
                            options: QuillToolbarToggleStyleButtonOptions(
                                iconTheme: QuillIconTheme(
                                    iconButtonUnselectedData: IconButtonData(
                                        color: secondToolbarBtnClr))),
                            controller: _controller,
                            attribute: Attribute.ul,
                          ),
                          QuillToolbarToggleStyleButton(
                            options: QuillToolbarToggleStyleButtonOptions(
                                iconTheme: QuillIconTheme(
                                    iconButtonUnselectedData: IconButtonData(
                                        color: secondToolbarBtnClr))),
                            controller: _controller,
                            attribute: Attribute.inlineCode,
                          ),
                          const VerticalDivider(
                            endIndent: 10,
                            indent: 10,
                          ),
                          QuillToolbarToggleStyleButton(
                            options: QuillToolbarToggleStyleButtonOptions(
                                iconTheme: QuillIconTheme(
                                    iconButtonUnselectedData: IconButtonData(
                                        color: secondToolbarBtnClr))),
                            controller: _controller,
                            attribute: Attribute.blockQuote,
                          ),
                          QuillToolbarIndentButton(
                            options: QuillToolbarIndentButtonOptions(
                                iconTheme: QuillIconTheme(
                                    iconButtonUnselectedData: IconButtonData(
                                        color: secondToolbarBtnClr))),
                            controller: _controller,
                            isIncrease: true,
                          ),
                          QuillToolbarIndentButton(
                            options: QuillToolbarIndentButtonOptions(
                                iconTheme: QuillIconTheme(
                                    iconButtonUnselectedData: IconButtonData(
                                        color: secondToolbarBtnClr))),
                            controller: _controller,
                            isIncrease: false,
                          ),
                          const VerticalDivider(
                            endIndent: 10,
                            indent: 10,
                          ),
                          QuillToolbarLinkStyleButton(
                            options: QuillToolbarLinkStyleButtonOptions(
                                iconTheme: QuillIconTheme(
                                    iconButtonUnselectedData: IconButtonData(
                                        color: secondToolbarBtnClr))),
                            controller: _controller,
                          ),
                          QuillToolbarSearchButton(
                            options: QuillToolbarSearchButtonOptions(
                                iconTheme: QuillIconTheme(
                                    iconButtonUnselectedData: IconButtonData(
                                        color: secondToolbarBtnClr))),
                            controller: _controller,
                          ),
                          // QuillToolbar
                        ],
                      ),
                    )),
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
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: TextStyle(color: Colors.black26),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                ),
                Expanded(
                  child: QuillEditor.basic(
                    controller: _controller,
                    configurations: QuillEditorConfigurations(
                      placeholder: 'Write down your note',
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      sharedConfigurations: const QuillSharedConfigurations(
                        locale: Locale('en'),
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

  Future<dynamic> showNoteBookOptions(BuildContext context, Note? note) {
    return showDialog(
        context: context,
        builder: (ctx) {
          final noteBooks = context.read<AppProvider>().noteBooks;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: ListView.builder(
                itemCount: noteBooks.length,
                itemBuilder: (ctx, index) {
                  return TextButton(
                      onPressed: () {
                        final noteBookTitle = noteBooks[index].title;
                        toastification.show(
                          type: ToastificationType.success,
                          style: ToastificationStyle.minimal,
                          context:
                              context, // optional if you use ToastificationWrapper
                          title: Text('Successfull add to $noteBookTitle'),
                          autoCloseDuration: const Duration(seconds: 3),
                        );
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
                        // TODO add toast
                      },
                      child: Text(
                        noteBooks[index].title,
                        style: TextStyle(color: Colors.black),
                      ));
                }),
          );
        });
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
