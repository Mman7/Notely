import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notely/src/provider/app_data.dart';
import 'package:provider/provider.dart';
import 'package:notely/src/model/folder_model.dart';
import 'package:notely/src/model/note_model.dart';
import 'package:notely/src/modules/local_database.dart';
import 'package:notely/src/provider/app_status.dart';
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
  late Note _note;
  bool isEditing = false;
  bool isNew = false;

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
    isNew = widget.isNew;
    _note = widget.note;

    if (!widget.isNew) {
      // load content
      if (originalContent.isEmpty) {
        originalContent = r'[{"insert":"\n"}]';
      } else {
        List json = jsonDecode(originalContent);
        _controller.document = Document.fromJson(json);
      }
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

  void showToaster({required String text}) {
    toastification.show(
      style: ToastificationStyle.minimal,
      primaryColor: Colors.lightGreen,
      icon: Icon(Icons.done),
      context: context, // optional if you use ToastificationWrapper
      title: Text(text),
      pauseOnHover: false,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  void saveContent() {
    String title = _titleController.text;
    Delta content = _controller.document.toDelta();
    String preview = _controller.document.toPlainText();
    preview = preview.length > 70
        ? preview.substring(0, 70)
        : preview; // Limit preview to 70 characters

    String json = jsonEncode(content);
    Database.addNote(
      note: Note(
          id: _note.id,
          title: title,
          content: json,
          dateCreated: DateTime.now(),
          uuid: widget.note.uuid,
          previewContent: preview,
          lastestModified: DateTime.now()),
    );
    setState(() => isChanged.value = false);
    editorFocusNode.unfocus();
    context.read<AppData>().refreshAll();
  }

  /// Updates the widget's properties with the latest note data from the provider.
  void bindLastestNote() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Note lastestNote = context.read<AppData>().noteList.last;
      setState(() {
        _note = lastestNote;
        isEditing = false;
        isNew = false;
        isChanged.value = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<FolderModel> folderList = context.watch<AppData>().folderList;
    DeviceType deviceType = context.read<AppStatus>().getDeviceType();
    // Check is editing
    editorFocusNode.addListener(() {
      if (editorFocusNode.hasFocus) setState(() => isEditing = true);
    });

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).textTheme.bodyLarge?.color,
            onPressed: () {
              if (isChanged.value) {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    title: Text('Unsaved Changes'),
                    content: Text(
                        'You have unsaved changes. Do you want to save them?'),
                    actions: [
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all(Colors.red),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all(
                              Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                        onPressed: () {
                          saveContent();
                          if (isNew) bindLastestNote();
                          setState(() => isEditing = false);
                          showToaster(text: 'Your note has been saved');
                          Navigator.of(context).pop();
                          Navigator.of(context).pop(); // Close editor
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                );
              } else {
                Navigator.of(context).pop(); // Close editor
              }
            },
          ),
          elevation: 7.0,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          surfaceTintColor: Colors.transparent,
          actions: [editorAction(), editorPopUp(folderList)],
          title: Text(
            'NotelyEditor',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Container(
          color: Theme.of(context).brightness != Brightness.dark
              ? Theme.of(context).colorScheme.tertiary
              : Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  if (deviceType == DeviceType.windows)
                    Toolbar(controller: _controller, deviceType: deviceType),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        TitleWidget(titleController: _titleController),
                        Divider(
                          thickness: 1,
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 16),
                      child: QuillEditor.basic(
                        controller: _controller,
                        focusNode: editorFocusNode,
                        config: const QuillEditorConfig(),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: mobileToolbar(deviceType))
            ],
          ),
        ));
  }

  Widget editorPopUp(List<FolderModel> folderList) {
    // if isnew show popupmenu else nothing
    return !isNew
        ? PopupMenuButton<int>(
            iconColor: Theme.of(context).textTheme.bodyLarge?.color,
            color: Theme.of(context).colorScheme.surfaceContainer,
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainer,
                                title: Text(
                                  'Select Folder',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color),
                                ),
                                children: [
                                  ...folderList.map((folder) {
                                    return SimpleDialogOption(
                                      onPressed: () {
                                        // Handle folder selection here
                                        List noteInFolder =
                                            folder.getNoteIncluded;
                                        // Prevent id contained
                                        if (noteInFolder
                                            .contains(widget.note.id)) {
                                          showToaster(
                                              text:
                                                  'Your note has been added to ${folder.title}');
                                          Navigator.of(context).pop();
                                          return;
                                        } else {
                                          folder.addNote(noteId: _note.id);
                                          context
                                              .read<AppData>()
                                              .intializeFolder();
                                          showToaster(
                                              text:
                                                  'Your note has been added ${folder.title}');
                                          Navigator.of(context).pop();
                                        }
                                        //else update folder's note included
                                      },
                                      child: Center(child: Text(folder.title)),
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
                        Icon(
                          Icons.folder,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        SizedBox(width: 8),
                        Text('Add to folder',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainer,
                                title: Text(
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color),
                                  'Remove from Folder',
                                  textAlign: TextAlign.center,
                                ),
                                children: [
                                  for (var folder in folderList)
                                    if (folder.getNoteIncluded
                                        .contains(widget.note.id))
                                      SimpleDialogOption(
                                        onPressed: () {
                                          // Remove note from folder
                                          folder.removeNote(
                                              noteId: widget.note.id);

                                          showToaster(
                                              text:
                                                  'Your note has been removed from ${folder.title}');
                                          context.read<AppData>().refreshAll();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child:
                                            Center(child: Text(folder.title)),
                                      ),
                                ]);
                          },
                        );
                      });
                    },
                    value: 3,
                    child: Row(
                      children: [
                        Icon(
                          Icons.drive_file_move_rtl_outlined,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        SizedBox(width: 8),
                        Text('Remove from Folder',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainer,
                          title: Text('Delete Note'),
                          content: Text(
                              'Are you sure you want to delete this note?'),
                          actions: [
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    WidgetStateProperty.all(Colors.grey),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Database.deleteNote(note: widget.note);
                                context.read<AppData>().refreshAll();

                                showToaster(text: 'Your note has been deleted');
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
                        Icon(
                          Icons.delete,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        SizedBox(width: 8),
                        Text('Delete Note',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color)),
                      ],
                    ),
                  ),
                ])
        : Container();
  }

  //CHeck if the content has changed
  ValueListenableBuilder<bool> editorAction() {
    return ValueListenableBuilder(
      valueListenable: isChanged,
      builder: (context, changed, child) => changed
          ? IconButton(
              onPressed: () {
                // Save the content
                saveContent();
                if (isNew) {
                  bindLastestNote();
                }
                showToaster(text: 'Your note has been saved');
              },
              icon: Icon(
                Icons.done,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            )
          : Container(),
    );
  }

  Widget mobileToolbar(DeviceType deviceType) {
    if (deviceType == DeviceType.windows) return Container();
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
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 15,
                offset: Offset(0, 2),
                spreadRadius: 1),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: ScrollPhysics(),
          controller: ScrollController(),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse, // 👈 allow mouse scroll wheel
                PointerDeviceKind.trackpad,
              },
            ),
            child: QuillSimpleToolbar(
                controller: _controller,
                config: QuillSimpleToolbarConfig(
                  color: Colors.red,
                  axis: Axis.horizontal,
                  buttonOptions: QuillSimpleToolbarButtonOptions(
                      backgroundColor: QuillToolbarColorButtonOptions(),
                      base: QuillToolbarBaseButtonOptions(
                          iconTheme: QuillIconTheme(
                              iconButtonUnselectedData: IconButtonData(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color),
                              iconButtonSelectedData:
                                  IconButtonData(style: ButtonStyle())))),
                )),
          ),
        ));
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
    return TextField(
      style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: 30,
          fontWeight: FontWeight.w700),
      controller: _titleController,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        border: InputBorder.none,
        fillColor: Colors.transparent,
        hintText: 'Title',
        hoverColor: Colors.transparent,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );
  }
}
