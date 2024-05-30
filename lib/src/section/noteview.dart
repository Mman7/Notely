import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/myobjectbox.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/provider/app_provider.dart';
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
      titleController.text = note.title;
      // set content
      var rawData = jsonDecode(note.content);
      _controller.document = Document.fromJson(rawData);
      debugPrint(note.id.toString());
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
            flex: 1,
            child: Container(
              color: Colors.yellow,
              child: QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  customButtons: [
                    QuillToolbarCustomButtonOptions(
                      icon: const Icon(Icons.check),
                      tooltip: 'Save',
                      onPressed: () {
                        saveData(note, context);
                      },
                    ),
                  ],
                  controller: _controller,
                  sharedConfigurations: const QuillSharedConfigurations(
                    locale: Locale('en'),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(fontSize: 25),
                  decoration: const InputDecoration(
                    //TODO get rid of border line
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    filled: true,
                    hintText: 'New Note',
                    fillColor: Colors.white,
                    border: InputBorder.none,
                  ),
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

  void saveData(Note? note, BuildContext context) {
    var data = _controller.document.toDelta();
    var jsonData = jsonEncode(data);
    var plainText = _controller.document.toPlainText();
    final noteBox = objectbox.store.box<Note>();

    // if note is selected update data
    if (note != null) {
      var id = note.id;
      var updateNote = Note(
          id: id,
          previewContent: plainText,
          uuid: note.uuid,
          title: titleController.text,
          content: jsonData,
          dateCreated: DateTime.now());
      noteBox.put(updateNote);
      context.read<AppProvider>().refresh();

      // refresh current editing note
      context.read<AppProvider>().setNoteSelected(id: note.id);

      debugPrint('update');
      return;
    }

    // else create new Note
    var newNote = Note(
        previewContent: plainText,
        uuid: const Uuid().v4(),
        title: 'this is title',
        content: jsonData,
        dateCreated: DateTime.now());

    noteBox.put(newNote);
    context.read<AppProvider>().refresh();
    debugPrint('saved');
    return;
  }
}
