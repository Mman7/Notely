import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/model/folder_model.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/modules/local_database.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/widget/note_preview.dart';

class NoteList extends StatefulWidget {
  NoteList({super.key, this.folder});
  FolderModel? folder;
  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Note> _noteList = [];
  List<Note> _backupList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DeviceType deviceType = context.read<AppProvider>().getDeviceType();
    context.watch<AppProvider>().folderList;
    // Check if the folder is not null and filter notes by folder
    if (widget.folder != null) {
      List<Note> data =
          Database().filterNoteByFolder(ids: widget.folder?.getNoteIncluded) ??
              [];
      setState(() {
        _noteList = data;
        _backupList = data;
      });
    }
    // Load all notes if no folder is selected
    if (widget.folder == null && _searchController.text.isEmpty) {
      setState(() {
        _noteList = context.watch<AppProvider>().noteList;
        _backupList = context.watch<AppProvider>().noteList;
      });
    }

    search({required List<Note> list, required String text}) {
      return list.where((note) {
        return note.title.contains(text);
      }).toList();
    }

    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _noteList = _backupList;
        });
      }
      if (_searchController.text.isNotEmpty) {
        List<Note> list = search(list: _noteList, text: _searchController.text);
        setState(() {
          _noteList = list;
        });
      }
    });
    int checkScreen() {
      if (ScreenUtil().screenWidth > 1500) return 8;
      if (deviceType == DeviceType.mobile) return 2;
      if (deviceType == DeviceType.tablet) return 3;
      if (deviceType == DeviceType.windows) return 5;
      return 2;
    }

    bool isMobileOrTable =
        deviceType == DeviceType.mobile || deviceType == DeviceType.tablet;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          onPressed: () {
            if (_isSearching) setState(() => _isSearching = !_isSearching);
            Navigator.of(context).pop();
          },
        ),
        elevation: 7.0,
        backgroundColor: Colors.white,
        shadowColor: Colors.grey.shade100,
        surfaceTintColor:
            Colors.transparent, // Prevents color change due to elevation
        title: title(
            folderName: widget.folder?.title ?? 'All notes',
            isMobileOrTable: isMobileOrTable,
            isSearching: _isSearching),
        actions: [
          _isSearching
              ? IconButton(
                  onPressed: () => setState(() => _isSearching = !_isSearching),
                  icon: Icon(Icons.cancel_sharp))
              : menuOptions(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20),
        child: GridView.builder(
          padding: EdgeInsets.all(10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: checkScreen(), // Number of columns
            crossAxisSpacing: 15.0,
            mainAxisSpacing: 15.0,
            childAspectRatio: 3 / 4, // Adjust the aspect ratio as needed
          ),
          itemCount: _noteList.length, // Number of items
          itemBuilder: (context, index) {
            return NotePreview(
                index: index,
                title: _noteList[index].title,
                previewContent: _noteList[index].previewContent,
                content: _noteList[index].content,
                lastModified: DateTime.now());
          },
        ),
      ),
    );
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
                      child: Text('Yes', style: TextStyle(color: Colors.white)),
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
              hintStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: Colors.black),
            onChanged: (value) {
              // Implement search logic
            },
          )
        : Text(overflow: TextOverflow.fade, folderName ?? 'Note List');
  }
}
