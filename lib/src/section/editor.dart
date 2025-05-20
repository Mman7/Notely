import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/modules/local_database.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:uuid/uuid.dart';

class Editor extends StatefulWidget {
  const Editor({
    super.key,
    required this.title,
    required this.content,
    this.uuid,
    this.id,
  });
  final String title;
  final String content;
  final String? uuid;
  final int? id;
  @override
  State createState() => _EditorState();
}

/// TODO Add bottom sticky bar for mobile
class _EditorState extends State<Editor> {
  final QuillController _controller = QuillController.basic();
  final _titleController = TextEditingController();
  bool isChanged = true;

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
    var json = jsonDecode(originalContent);

    _controller.document = Document.fromJson(json);

    _controller.addListener(() {
      List<Map<String, dynamic>> aaa = _controller.document.toDelta().toJson();
      // setState(() => isChanged = !isContentChanged(aaa, data));
    });
    super.initState();
  }

  isNewNote() => widget.content.isEmpty;
  // Check if the content has changed
  bool isContentChanged(List<Map<String, dynamic>> value1,
          List<Map<String, dynamic>> value2) =>
      mapEquals(value1[0], value2[0]);

  @override
  Widget build(BuildContext context) {
    AppProvider provider = context.read<AppProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          isChanged
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

                    provider.refresh();
                  },
                  icon: const Icon(Icons.save),
                )
              : Container()
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
