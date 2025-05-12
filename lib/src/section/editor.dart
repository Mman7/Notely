import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class Editor extends StatefulWidget {
  const Editor({
    super.key,
  });

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
    _controller.document = Document.fromJson([
      {
        'insert':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed est magna. Cras vehicula vel augue eget vulputate. Ut suscipit urna et ligula hendrerit, at volutpat turpis tempus. Maecenas ac sapien mi. Integer sit amet lacus risus. Morbi ac odio quis sem convallis finibus. Proin tincidunt tortor et nunc viverra, non interdum nibh rutrum. Sed maximus urna vitae massa egestas faucibus. Pellentesque mattis leo purus, ultrices rutrum ex rhoncus sit amet. Vestibulum tristique sodales metus non mollis. Quisque et molestie lorem. Aliquam nec risus et lorem viverra euismod at id ante. Proin consectetur venenatis enim, eu aliquet dui tempus a. Aenean mattis lorem et lorem ornare consectetur.\n',
      },
    ]);
    super.initState();
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
