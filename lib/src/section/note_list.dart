import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/widget/note_preview.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    DeviceType deviceType = context.read<AppProvider>().getDeviceType();
    List<Note> noteList = context.watch<AppProvider>().noteList;
    int checkScreen() {
      if (ScreenUtil().screenWidth > 1500) return 8;
      if (deviceType == DeviceType.mobile) return 2;
      if (deviceType == DeviceType.tablet) return 3;
      if (deviceType == DeviceType.windows) return 5;
      return 2;
    }

    var isMobileOrTable =
        deviceType == DeviceType.mobile || deviceType == DeviceType.tablet;

    return Scaffold(
      appBar: AppBar(
        elevation: 7.0,
        backgroundColor: Colors.white,
        shadowColor: Colors.grey.shade100,
        surfaceTintColor:
            Colors.transparent, // Prevents color change due to elevation
        title: title(isSearching, isMobileOrTable),
        actions: [
          isSearching
              ? IconButton(
                  onPressed: () => setState(() => isSearching = !isSearching),
                  icon: Icon(Icons.cancel_sharp))
              : menuOptions(isMobileOrTable),
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
          itemCount: noteList.length, // Number of items
          itemBuilder: (context, index) {
            return NotePreview(
              index: index,
              title: noteList[index].title,
              previewContent: noteList[index].previewContent,
              content: noteList[index].content,
              lastModified: DateTime.now(),
            );
          },
        ),
      ),
    );
  }

  PopupMenuButton<String> menuOptions(bool isMobileOrTable) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert, color: Colors.black),
      onSelected: (value) {
        if (value == 'search') {
          setState(() => isSearching = !isSearching);
        } else if (value == 'delete_folder') {}
      },
      itemBuilder: (context) => [
        PopupMenuItem(
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

  Widget title(isSearching, isMobileOrTable) {
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
        : Text('Note List');
  }
}
