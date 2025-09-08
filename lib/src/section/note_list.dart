import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:notely/src/model/folder_model.dart';
import 'package:notely/src/model/note_model.dart';
import 'package:notely/src/modules/local_database.dart';
import 'package:notely/src/provider/app_provider.dart';
import 'package:notely/src/widget/note_preview.dart';
import 'package:toastification/toastification.dart';

class NoteList extends StatefulWidget {
  NoteList({super.key, this.folder, this.isSearching});
  FolderModel? folder;
  bool? isSearching;

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Note> _noteList = [];
  List<Note> _backupList = [];

  searchUp(List list) {
    String seachText = _searchController.text;
    return list
        .where((note) =>
            note.title.toLowerCase().contains(seachText.toLowerCase()))
        .toList();
  }

  sortListbyDate() {
    setState(() {
      _noteList.sort((a, b) => b.lastestModified.compareTo(a.lastestModified));
    });
  }

  List<Note> getData(folder) {
    return Database()
        .filterNoteByFolder(ids: widget.folder?.getNoteIncluded)
        .whereType<Note>()
        .toList();
  }

  intializeNoteFromFolder() {
    // intialize the note list based on whether a folder is provided
    if (widget.folder != null) {
      _noteList = getData(widget.folder);
      _backupList = getData(widget.folder);
    }
  }

  @override
  void initState() {
    super.initState();
    intializeNoteFromFolder();

    _searchController.addListener(() {
      String text = _searchController.text;
      if (text.isNotEmpty) setState(() => _noteList = searchUp(_noteList));
      if (text.isEmpty) setState(() => _noteList = _backupList);
    });
  }

  int checkScreen(DeviceType deviceType) {
    if (ScreenUtil().screenWidth > 1400) return 8;
    if (deviceType == DeviceType.mobile) return 2;
    if (deviceType == DeviceType.tablet) return 3;
    if (deviceType == DeviceType.windows) return 5;
    return 2;
  }

  scrollToBtm() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 275), curve: Curves.bounceInOut);
  }

  @override
  Widget build(BuildContext context) {
    DeviceType deviceType = context.watch<AppProvider>().getDeviceType();
    List<Note> allNotes = context.watch<AppProvider>().noteList;
    sortListbyDate();

    if (widget.folder == null && !_isSearching) {
      _noteList = allNotes;
      _backupList = allNotes;
      // Initializing the note list based on the folder
      // then check if the widget is searching
      if (widget.isSearching != null) {
        _isSearching = widget.isSearching!;
      }
    }

    bool isMobileOrTable =
        deviceType == DeviceType.mobile || deviceType == DeviceType.tablet;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            onPressed: () {
              int index = context.read<AppProvider>().pageIndex;
              if (_isSearching) setState(() => _isSearching = !_isSearching);
              if (index != 0) {
                context.read<AppProvider>().setPageIndex(0);
                return;
              } else {
                context.read<AppProvider>().setPageIndex(0);
                Navigator.of(context).pop();
              }
            },
          ),
          elevation: 7.0,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          surfaceTintColor:
              Colors.transparent, // Prevents color change due to elevation
          title: title(
              folderName: widget.folder?.title ?? 'All notes',
              isMobileOrTable: isMobileOrTable,
              isSearching: _isSearching),
          actions: [
            _isSearching
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                        if (widget.isSearching != null) {
                          widget.isSearching = false;
                        }
                      });
                    },
                    icon: Icon(
                      Icons.cancel_sharp,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ))
                : menuOptions(_noteList),
          ],
        ),
        body: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: checkScreen(deviceType), // Number of columns
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 3 / 4, // Adjust the aspect ratio as needed
              ),
              itemCount: _noteList.length, // Number of items
              itemBuilder: (context, index) {
                return NotePreview(index: index, note: _noteList[index]);
              }),
        ));
  }

  PopupMenuButton<String> menuOptions(List<Note> noteList) {
    return PopupMenuButton(
      color: Theme.of(context).colorScheme.surface,
      icon: Icon(Icons.more_vert,
          color: Theme.of(context).textTheme.bodyLarge?.color),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () => setState(() => _isSearching = !_isSearching),
          value: 'search',
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              SizedBox(width: 8),
              Text('Search'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            if (widget.folder == null) {
              Database().addNote(note: Note.newNote());
              scrollToBtm();
              context.read<AppProvider>().refreshNote();
            } else {
              if (widget.folder == null) throw Error();
              Database().addNote(note: Note.newNote());
              Note lastestNote = context.read<AppProvider>().noteList.last;
              widget.folder?.addNote(noteId: lastestNote.id);
              scrollToBtm();
              intializeNoteFromFolder();
              context.read<AppProvider>().refreshAll();
            }
          },
          value: 'search',
          child: Row(
            children: [
              Icon(
                Icons.add_box_outlined,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              SizedBox(width: 8),
              Text('Add note'),
            ],
          ),
        ),
        if (widget.folder?.id != null)
          PopupMenuItem(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  title: Text('Delete Folder'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Are you sure you want to delete this folder?'),
                      SizedBox(height: 8),
                      Text(
                        'This action cannot be undone.',
                        style: TextStyle(fontSize: 13, color: Colors.redAccent),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                      ),
                      onPressed: () {
                        if (widget.folder?.id == null) return;
                        Database().deleteFolder(id: widget.folder?.id);
                        context.read<AppProvider>().refreshAll();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        toastification.show(
                          style: ToastificationStyle.minimal,
                          primaryColor: Colors.lightGreen,
                          icon: Icon(Icons.done),
                          context:
                              context, // optional if you use ToastificationWrapper
                          title: Text('Folder deleted'),
                          pauseOnHover: false,
                          autoCloseDuration: const Duration(seconds: 2),
                        );
                      },
                      child: Text('Comfirm',
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ),
                  ],
                ),
              );
            },
            value: 'delete_folder',
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                SizedBox(width: 8),
                Text('Delete Folder'),
              ],
            ),
          )
      ],
    );
  }

  Widget title(
      {required bool isSearching,
      required bool isMobileOrTable,
      String? folderName}) {
    return isSearching
        ? TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
                hintText: 'Search notes...',
                fillColor: Colors.transparent,
                hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(12)),
            cursorColor: Theme.of(context).textTheme.bodyLarge?.color,
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
            onChanged: (value) {},
          )
        : Text(
            overflow: TextOverflow.fade,
            folderName ?? 'Note List',
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w600),
          );
  }
}
