
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class Editor extends StatefulWidget {
  const Editor({
    super.key,
    required this.title,
    required this.content,
  });
  final String title;
  final String content;
  @override
  State createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final QuillController _controller = QuillController.basic();
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _titleController.text = widget.title;
    var originalContent = widget.content;
    // test data
    List<Map<String, dynamic>> data = [
      {
        "insert": '$originalContent\n',
      }
    ];
    _controller.document = Document.fromJson(data);

    _controller.addListener(() {
      var aaa = _controller.document.toDelta().toJson();
      print(mapEquals(aaa[0], data[0]));
    });
    super.initState();
  }

  // Check if the content has changed
  bool isContentChanged(
      List<Map<String, dynamic>> value1, List<Map<String, dynamic>> value2) {
    if (value1.length != value2.length) {
      return true;
    }
    return mapEquals(value1[0], value2[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MeloEditor'),
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
