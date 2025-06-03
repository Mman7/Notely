import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/modules/local_database.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/widget/note_preview.dart';

class NoteList extends StatefulWidget {
  NoteList(
      {super.key,
      required this.folderId,
      required this.noteIncluded,
      required this.folderName});
  int? folderId;
  String? folderName;
  List<int>? noteIncluded;
  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  bool isSearching = false;
  List _noteList = [];

  @override
  Widget build(BuildContext context) {
    DeviceType deviceType = context.read<AppProvider>().getDeviceType();
    // Load data
    if (widget.noteIncluded == null) {
      setState(() => _noteList = context.watch<AppProvider>().noteList);
    }
    if (widget.noteIncluded != null) {
      List data = Database().filterNoteByFolder(ids: widget.noteIncluded);
      _noteList = data;
    }

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
        elevation: 7.0,
        backgroundColor: Colors.white,
        shadowColor: Colors.grey.shade100,
        surfaceTintColor:
            Colors.transparent, // Prevents color change due to elevation
        title: title(
            folderName: widget.folderName,
            isMobileOrTable: isMobileOrTable,
            isSearching: isSearching),
        actions: [
          isSearching
              ? IconButton(
                  onPressed: () => setState(() => isSearching = !isSearching),
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
              lastModified: DateTime.now(),
            );
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
          onTap: () => setState(() => isSearching = !isSearching),
          value: 'search',
          child: Row(
            children: [
              Icon(Icons.search),
              SizedBox(width: 8),
              Text('Search'),
            ],
          ),
        ),
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
                      if (widget.folderId != null) {
                        Database().removeFolder(id: widget.folderId);
                        context.read<AppProvider>().refresh();
                      }
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

            // if (widget.folderId == null) return;
            // Database().removeFolder(id: widget.folderId);
            // context.read<AppProvider>().refresh();
            // Navigator.of(context).pop();
          },
          value: 'delete_folder',
          child: Row(
            children: [
              Icon(Icons.delete),
              SizedBox(width: 8),
              Text('Delete Folder'),
            ],
          ),
        ),
      ],
    );
  }

  Widget actionButton(bool isMobileOrTable) {
    return isMobileOrTable
        ? IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() => isSearching = !isSearching);
            },
          )
        : Container();
  }

  Widget title(
      {required bool isSearching,
      required bool isMobileOrTable,
      String? folderName}) {
    return isSearching && isMobileOrTable
        ? TextField(
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
