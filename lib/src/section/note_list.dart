import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:melonote/src/model/folder_model.dart';
import 'package:melonote/src/model/note_model.dart';
import 'package:melonote/src/modules/local_database.dart';
import 'package:melonote/src/provider/app_provider.dart';
import 'package:melonote/src/widget/note_preview.dart';

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
  List<Note> _noteList = [];
  List<Note> _backupList = [];

  searchUp(List list) {
    String seachText = _searchController.text;
    return list.where((note) => note.title.contains(seachText)).toList();
  }

  List<Note> getData(folder) {
    return Database()
        .filterNoteByFolder(ids: widget.folder?.getNoteIncluded)
        .whereType<Note>()
        .toList();
  }

  @override
  void initState() {
    // intialize the note list based on whether a folder is provided

    if (widget.folder != null) {
      _noteList = getData(widget.folder);
      _backupList = getData(widget.folder);
    }
    super.initState();
    // CHECK if the widget is searching show up search , else show up all notes
    _searchController.addListener(() {
      String text = _searchController.text;
      if (text.isNotEmpty) setState(() => _noteList = searchUp(_noteList));
      if (text.isEmpty) setState(() => _noteList = _backupList);
    });
  }

  int checkScreen(DeviceType deviceType) {
    if (ScreenUtil().screenWidth > 1200) return 5;
    if (deviceType == DeviceType.mobile) return 2;
    if (deviceType == DeviceType.tablet) return 3;
    if (deviceType == DeviceType.windows) return 4;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    DeviceType deviceType = context.watch<AppProvider>().getDeviceType();
    if (widget.folder == null && !_isSearching) {
      List<Note> allNotes = context.watch<AppProvider>().noteList;
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
                      // print(widget.isSearching = false);
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(Icons.cancel_sharp))
                : menuOptions(),
          ],
        ),
        body: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: GridView.builder(
              padding: EdgeInsets.all(30.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: checkScreen(deviceType), // Number of columns
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                childAspectRatio: 3 / 4, // Adjust the aspect ratio as needed
              ),
              itemCount: _noteList.length, // Number of items
              itemBuilder: (context, index) {
                return NotePreview(index: index, note: _noteList[index]);
              }),
        ));
  }

  PopupMenuButton<String> menuOptions() {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert, color: Colors.black),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () => setState(() => _isSearching = !_isSearching),
          value: 'search',
          child: Row(
            children: [
              Icon(Icons.search),
              SizedBox(width: 8),
              Text('Search'),
            ],
          ),
        ),
        if (widget.folder?.id != null)
          PopupMenuItem(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
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
                        context.read<AppProvider>().refresh();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text('Comfirm',
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              );
            },
            value: 'delete_folder',
            child: Row(
              children: [
                Icon(Icons.delete),
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
              fillColor: Colors.white,
              hintText: 'Search notes...',
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.secondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: Colors.black),
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
