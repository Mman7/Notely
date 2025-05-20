import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/modules/local_database.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

class Editor extends StatefulWidget {
  const Editor({
    super.key,
    required this.title,
    required this.content,
    this.uuid,
    this.id,
    required this.isNew,
  });
  final String title;
  final String content;
  final String? uuid;
  final int? id;
  final bool isNew;
  @override
  State createState() => _EditorState();
}

/// TODO Add bottom sticky bar for mobile
class _EditorState extends State<Editor> {
  final QuillController _controller = QuillController.basic();
  final _titleController = TextEditingController();
  ValueNotifier<bool> isChanged = ValueNotifier(false);

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _titleController.text = widget.title;
    String originalContent = widget.content;
    if (originalContent.isEmpty) {
      return;
    }
    // intialize content
    List json = jsonDecode(originalContent);
    _controller.document = Document.fromJson(json);

    // Check if title has changed
    _titleController.addListener(() {
      if (_titleController.text != widget.title) {
        isChanged.value = true;
      } else {
        isChanged.value = false;
      }
    });

    // Check if the content has changed
    _controller.document.changes.listen((event) {
      final change = event.change;
      if (change.isNotEmpty) {
        isChanged.value = true;
      } else {
        isChanged.value = false;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider provider = context.read<AppProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          ValueListenableBuilder(
            valueListenable: isChanged,
            builder: (context, changed, child) => changed || widget.isNew
                ? IconButton(
                    onPressed: () {
                      // Save the content
                      String title = _titleController.text;
                      Delta content = _controller.document.toDelta();
                      String preview = _controller.document.toPlainText();
                      var json = jsonEncode(content);
                      Database().saveNote(
                        note: Note(
                          id: widget.id ?? 0,
                          title: title,
                          content: json,
                          dateCreated: DateTime.now(),
                          uuid: widget.uuid ?? Uuid().v4(),
                          previewContent: preview,
                        ),
                      );
                      toastification.show(
                        style: ToastificationStyle.fillColored,
                        primaryColor: Colors.lightGreen,
                        icon: Icon(Icons.done),
                        context:
                            context, // optional if you use ToastificationWrapper
                        title: Text('Your note has been saved'),
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                      provider.refresh();
                      isChanged.value = false;
                    },
                    icon: const Icon(Icons.done),
                  )
                : Container(),
          )
        ],
        title: const Text('MelosEditor'),
      ),
      body: Column(
        children: [
          Container(
              width: double.infinity,
              color: Colors.blue,
              child: QuillToolbar.simple(
                  controller: _controller,
                  configurations: QuillSimpleToolbarConfigurations(
                    sharedConfigurations: const QuillSharedConfigurations(
                      locale: Locale('en'),
                    ),
                  ))),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.red,
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  placeholder: 'Write down your note',
                  sharedConfigurations: const QuillSharedConfigurations(
                    locale: Locale('en'),
                  ),
                ),
                controller: _controller,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
