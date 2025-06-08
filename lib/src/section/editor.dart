import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/model/folder_model.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/modules/local_database.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:toastification/toastification.dart';

class Editor extends StatefulWidget {
  Editor({
    super.key,
    required this.note,
    required this.isNew,
  });
  bool isNew;
  Note note;
  @override
  State createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final QuillController _controller = QuillController.basic();
  final _titleController = TextEditingController();
  FocusNode editorFocusNode = FocusNode();
  ValueNotifier<bool> isChanged = ValueNotifier(false);
  bool isEditing = false;

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _titleController.text = widget.note.title;
    String originalContent = widget.note.content;

    if (!widget.isNew) {
      // load content
      List json = jsonDecode(originalContent);
      _controller.document = Document.fromJson(json);
    }

    // Check if title has changed
    _titleController.addListener(() {
      if (isChanged.value == true) return;
      if (_titleController.text != widget.note.title) isChanged.value = true;
      if (_titleController.text == widget.note.title) isChanged.value = false;
    });
    // Check if the content has changed
    _controller.document.changes.listen((event) {
      final change = event.change;
      if (change.isNotEmpty) isChanged.value = true;
      if (change.isEmpty) isChanged.value = false;
    });
    super.initState();
  }

  void saveContent() {
    String title = _titleController.text;
    Delta content = _controller.document.toDelta();
    String preview = _controller.document.toPlainText();
    var json = jsonEncode(content);
    Database().saveNote(
      note: Note(
        id: widget.note.id,
        title: title,
        content: json,
        dateCreated: DateTime.now(),
        uuid: widget.note.uuid,
        previewContent: preview,
      ),
    );
  }

  /// Updates the widget's properties with the latest note data from the provider.
  void refreshWhenSave() {
    Note note = context.read<AppProvider>().noteList.last;
    widget.note.title = note.title;
    widget.note.content = note.content;
    widget.note.id = note.id;
    widget.isNew = false;
    widget.note.uuid = note.uuid;
    isChanged.value = false;
    setState(() => isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    List folderList = context.watch<AppProvider>().folderList;
    DeviceType deviceType = context.read<AppProvider>().getDeviceType();

    // Check is editing
    editorFocusNode.addListener(() {
      if (editorFocusNode.hasFocus) setState(() => isEditing = true);
    });

    Widget titleTextField = TitleWidget(titleController: _titleController);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 6,
        shadowColor: Colors.grey.withAlpha(128),
        actions: [
          ValueListenableBuilder(
            valueListenable: isChanged,
            builder: (context, changed, child) => changed || widget.isNew
                ? IconButton(
                    onPressed: () {
                      // Save the content
                      saveContent();
                      toastification.show(
                          style: ToastificationStyle.fillColored,
                          primaryColor: Colors.lightGreen,
                          icon: Icon(Icons.done),
                          context:
                              context, // optional if you use ToastificationWrapper
                          title: Text('Your note has been saved'),
                          autoCloseDuration: const Duration(seconds: 2),
                          pauseOnHover: false);
                      context.read<AppProvider>().refresh();
                      refreshWhenSave();
                    },
                    icon: const Icon(Icons.done),
                  )
                : Container(),
          ),
          !widget.isNew
              ? PopupMenuButton<int>(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Note'),
                                content: Text(
                                    'Are you sure you want to delete this note?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Database database = Database();
                                      database.deleteNote(id: widget.note.id);
                                      context.read<AppProvider>().refresh();
                                      toastification.show(
                                        style: ToastificationStyle.minimal,
                                        primaryColor: Colors.lightGreen,
                                        icon: Icon(Icons.done),
                                        context: context,
                                        title:
                                            Text('Your note has been deleted'),
                                        pauseOnHover: false,
                                        autoCloseDuration:
                                            const Duration(seconds: 2),
                                      );

                                      // Close dialog and leave editor
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                          value: 1,
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.black),
                              SizedBox(width: 8),
                              Text('Delete Note'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    showToast() => toastification.show(
                                          style: ToastificationStyle.minimal,
                                          primaryColor: Colors.lightGreen,
                                          icon: Icon(Icons.done),
                                          context:
                                              context, // optional if you use ToastificationWrapper
                                          title:
                                              Text('Your note has been added'),
                                          pauseOnHover: false,
                                          autoCloseDuration:
                                              const Duration(seconds: 2),
                                        );

                                    return SimpleDialog(
                                      title: Text('Select Folder'),
                                      children: [
                                        ...folderList.map((e) {
                                          return SimpleDialogOption(
                                            onPressed: () {
                                              // Handle folder selection here
                                              List noteIncludedList =
                                                  e.getConvertNoteInclude();
                                              // Prevent id contained
                                              if (noteIncludedList
                                                  .contains(widget.note.id)) {
                                                showToast();
                                                Navigator.of(context).pop();
                                                return;
                                              }
                                              //else update folder's note included
                                              noteIncludedList
                                                  .add(widget.note.id);
                                              String encodeList =
                                                  jsonEncode(noteIncludedList);
                                              List folderList = widget.note
                                                  .getfolderIncluded();
                                              FolderModel newFolder =
                                                  FolderModel(
                                                      title: e.title,
                                                      id: e.id,
                                                      noteInclude: encodeList);
                                              Database().updateFolder(
                                                  folder: newFolder);
                                              // update note folder
                                              if (folderList.contains(e.id)) {
                                                return;
                                              } else {
                                                String newList = [
                                                  ...folderList,
                                                  e.id
                                                ].toString();
                                                Note updatedNote = Note(
                                                    id: widget.note.id,
                                                    uuid: widget.note.uuid,
                                                    title: widget.note.title,
                                                    content:
                                                        widget.note.content,
                                                    folder: newList,
                                                    previewContent: widget
                                                        .note.previewContent);
                                                Database().updateNote(
                                                    note: updatedNote);
                                              }

                                              context
                                                  .read<AppProvider>()
                                                  .refreshNoteBook();
                                              showToast();
                                              Navigator.of(context).pop();
                                            },
                                            child: Center(child: Text(e.title)),
                                          );
                                        })
                                      ],
                                    );
                                  });
                            });
                          },
                          value: 2,
                          child: Row(
                            children: [
                              Icon(Icons.folder, color: Colors.black),
                              SizedBox(width: 8),
                              Text('Add to folder'),
                            ],
                          ),
                        ),
                        // Add more menu items if needed
                      ])
              : Container()
        ],
        title: const Text('MeloEditor'),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                deviceType == DeviceType.windows
                    ? Toolbar(
                        controller: _controller,
                        deviceType: deviceType,
                      )
                    : Container(),
                titleTextField,
                // EDITOR
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: hexToColor('#FFFFFF'),
                    child: QuillEditor.basic(
                      focusNode: editorFocusNode,
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

            // Toolbar mobile
            deviceType == DeviceType.mobile || deviceType == DeviceType.tablet
                ? mobileToolbar(deviceType)
                : Container()
          ],
        ),
      ),
    );
  }

  Widget mobileToolbar(DeviceType deviceType) {
    return isEditing
        ? Column(
            children: [
              Spacer(),
              Toolbar(
                controller: _controller,
                deviceType: deviceType,
              ),
            ],
          )
        : Container();
  }
}

class Toolbar extends StatelessWidget {
  Toolbar(
      {super.key,
      required QuillController controller,
      required this.deviceType})
      : _controller = controller;

  final QuillController _controller;
  DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: deviceType == DeviceType.mobile
                    ? Colors.grey
                    : Colors.white,
                blurRadius: 20,
                offset: Offset(0, 2),
                spreadRadius: 3),
          ],
        ),
        child: QuillToolbar.simple(
            controller: _controller,
            configurations: QuillSimpleToolbarConfigurations(
              buttonOptions: QuillSimpleToolbarButtonOptions(
                  base: QuillToolbarBaseButtonOptions(
                      iconTheme: QuillIconTheme(
                          iconButtonSelectedData: IconButtonData(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withAlpha(200))))))),
              sharedConfigurations: const QuillSharedConfigurations(
                locale: Locale('en'),
              ),
            )));
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required TextEditingController titleController,
  }) : _titleController = titleController;

  final TextEditingController _titleController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: TextField(
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 30,
            fontWeight: FontWeight.w500),
        controller: _titleController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          border: InputBorder.none,
          fillColor: hexToColor('#FFFFFF'),
          hintText: 'Title',
          hoverColor: Colors.transparent,
        ),
      ),
    );
  }
}
