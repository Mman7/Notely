import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:melonote/src/model/folder_model.dart';
import 'package:melonote/src/model/note_model.dart';
import 'package:melonote/src/modules/local_database.dart';
import 'package:melonote/src/provider/app_provider.dart';
import 'package:melonote/src/widget/folder_view.dart';
import 'package:melonote/src/widget/folder_header.dart';
import 'package:toastification/toastification.dart';

class FolderListView extends StatelessWidget {
  FolderListView({super.key});
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<FolderModel> allFolders = context.watch<AppProvider>().folderList;
    List<Note> allNotes = context.watch<AppProvider>().noteList;

    int checkScreen() {
      DeviceType deviceType = context.read<AppProvider>().getDeviceType();
      if (ScreenUtil().screenWidth > 1400) return 6;
      if (deviceType == DeviceType.mobile) return 2;
      if (deviceType == DeviceType.tablet) return 4;
      if (deviceType == DeviceType.windows) return 5;
      return 2;
    }

    return ClipRRect(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 65,
          title: Text(
            'Folders',
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.bold),
          ),
          elevation: 12,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          surfaceTintColor: Theme.of(context).colorScheme.tertiary,
          shadowColor: Colors.black.withAlpha(50),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.surface,
          height: 100.sh,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: GridView.builder(
                padding: EdgeInsets.all(30),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: checkScreen(),
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 30,
                ),
                itemCount: allFolders.length + 2, // 1 for header 1 for footer
                itemBuilder: (context, index) {
                  // Header
                  if (index == 0) {
                    return FolderHeader(listCount: allNotes.length);
                  }
                  // Footer
                  if (index == allFolders.length + 1) {
                    return addNewFolderView(context);
                  }
                  var item = allFolders[index - 1];

                  return FolderView(
                    folder: item,
                  );
                }),
          ),
        ),
      ),
    );
  }

  Container addNewFolderView(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(100),
        borderRadius: BorderRadius.circular(13),
      ),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Text('Create New Folder'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _controller,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        labelText: 'Folder Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _controller.text = '';
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text == '') {
                        toastification.show(
                            title: Text("Name can't be emtpy"),
                            context:
                                context, // optional if ToastificationWrapper is in widget tree
                            alignment: Alignment.center,
                            style: ToastificationStyle.simple,
                            backgroundColor: Colors.red[400],
                            foregroundColor: Colors.white,
                            animationDuration: Duration(milliseconds: 200),
                            autoCloseDuration: Duration(milliseconds: 1300),
                            pauseOnHover: false,
                            type: ToastificationType.error);
                        return;
                      } else {
                        Database().addFolder(name: _controller.text);
                        context.read<AppProvider>().refresh();
                        // set text to nothing
                        _controller.text = '';
                        toastification.show(
                            style: ToastificationStyle.minimal,
                            primaryColor: Colors.lightGreen,
                            icon: Icon(Icons.done),
                            context:
                                context, // optional if you use ToastificationWrapper
                            title: Text('Your folder has been created'),
                            pauseOnHover: false,
                            autoCloseDuration: const Duration(seconds: 2));
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Create'),
                  ),
                ],
              );
            },
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 50.sp,
          ),
        ),
      ),
    );
  }
}
