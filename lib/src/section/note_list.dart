import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/section/editor.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    DeviceType deviceType =
        context.read<AppProvider>().getDeviceType(ScreenUtil().screenWidth);
    int checkScreen() {
      if (ScreenUtil().screenWidth > 1500) return 8;
      if (deviceType == DeviceType.mobile) return 2;
      if (deviceType == DeviceType.tablet) return 3;
      if (deviceType == DeviceType.windows) return 5;
      return 2;
    }

    var isMobileOrTable =
        deviceType == DeviceType.mobile || deviceType == DeviceType.tablet;

    var fakenotelist = [
      Note(
        content: 'This is a note',
        title: 'Note Title 1',
        lastestModified: DateTime.now(),
      ),
      Note(
        content: 'Another note content',
        title: 'Note Title 2',
        lastestModified: DateTime.now().subtract(Duration(days: 1)),
      ),
      Note(
        content: 'Yet another note',
        title: 'Note Title 3',
        lastestModified: DateTime.now().subtract(Duration(days: 2)),
      ),
      Note(
        content: 'Sample note content',
        title: 'Note Title 4',
        lastestModified: DateTime.now().subtract(Duration(days: 3)),
      ),
      Note(
        content: 'Fifth note content',
        title: 'Note Title 5',
        lastestModified: DateTime.now().subtract(Duration(days: 4)),
      ),
      Note(
        content: 'Sixth note content',
        title: 'Note Title 6',
        lastestModified: DateTime.now().subtract(Duration(days: 5)),
      ),
      Note(
        content: 'Seventh note content',
        title: 'Note Title 7',
        lastestModified: DateTime.now().subtract(Duration(days: 6)),
      ),
      Note(
        content: 'Eighth note content',
        title: 'Note Title 8',
        lastestModified: DateTime.now().subtract(Duration(days: 7)),
      ),
      Note(
        content: 'Ninth note content',
        title: 'Note Title 9',
        lastestModified: DateTime.now().subtract(Duration(days: 8)),
      ),
      Note(
        content: 'Tenth note content',
        title: 'Note Title 10',
        lastestModified: DateTime.now().subtract(Duration(days: 9)),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 7.0,
        backgroundColor: Colors.white,
        shadowColor: Colors.grey.shade100,
        surfaceTintColor:
            Colors.transparent, // Prevents color change due to elevation
        title: isSearching && isMobileOrTable
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
            : Text('Note List'),
        actions: [
          isMobileOrTable
              ? IconButton(
                  icon: Icon(isSearching ? Icons.close : Icons.search),
                  onPressed: () {
                    setState(() => isSearching = !isSearching);
                  },
                )
              : Container()
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
          itemCount: 10, // Number of items
          itemBuilder: (context, index) {
            return NotePreview(
              index: index,
              title: 'Note Title $index',
              previewText: 'This is a preview text for note $index.',
              lastModified: DateTime.now(),
            );
          },
        ),
      ),
    );
  }
}

class NotePreview extends StatelessWidget {
  const NotePreview({
    super.key,
    required this.index,
    required this.title,
    required this.previewText,
    required this.lastModified,
  });

  final int index;
  final String title;
  final String previewText;
  final DateTime lastModified;

  @override
  Widget build(BuildContext context) {
    String lastModifiedText() {
      List<String> date = lastModified.toLocal().toString().split('-');
      return '${date[0]}.${date[1]}.${date[2].split(' ')[0]}';
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Editor(
            title: title,
            content: previewText,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title $index',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'This is a paragraph for note $index.',
              style: TextStyle(fontSize: 14.0),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            // fake date
            Text(
              lastModifiedText(),
              style: TextStyle(
                fontSize: 12.sp,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
