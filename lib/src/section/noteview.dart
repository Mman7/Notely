import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

//TODO mobile if user editing show bottom sticky TOOLBAR

class NoteView extends StatelessWidget {
  NoteView({
    super.key,
  });
  final QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
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
            child: Container(
              color: Colors.purple,
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
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
    );
  }
}
