import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notely/src/provider/app_data.dart';
import 'package:provider/provider.dart';
import 'package:notely/src/model/folder_model.dart';
import 'package:notely/src/model/note_model.dart';
import 'package:notely/src/modules/local_database.dart';
import 'package:notely/src/provider/app_status.dart';
import 'package:notely/src/widget/folder_view.dart';
import 'package:notely/src/widget/folder_header.dart';
import 'package:toastification/toastification.dart';

class FolderListView extends StatelessWidget {
  FolderListView({super.key});
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<FolderModel> allFolders = context.watch<AppData>().folderList;
    List<Note> allNotes = context.watch<AppData>().noteList;

    int checkScreen() {
      DeviceType deviceType = context.read<AppStatus>().getDeviceType();
      if (ScreenUtil().screenWidth > 1400) return 7;
      if (deviceType == DeviceType.mobile) return 2;
      if (deviceType == DeviceType.tablet) return 4;
      if (deviceType == DeviceType.windows) return 5;
      return 2;
    }

    return ClipRect(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 65,
          shape: Border(
              left: BorderSide(color: Theme.of(context).colorScheme.tertiary)),
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
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            color: Theme.of(context).colorScheme.surfaceContainer,
          ),
          height: 100.sh,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: GridView.builder(
                padding: EdgeInsets.all(15),
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
    bool isDark = context.watch<AppStatus>().isDarkMode;
    return Container(
      margin: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(50),
        borderRadius: BorderRadius.circular(13),
      ),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Text(
                  'Create New Folder',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Folder Name',
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color),
                        fillColor:
                            Theme.of(context).colorScheme.surfaceContainer,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isDark ? Colors.white : Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isDark ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.grey),
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
                            backgroundColor:
                                Theme.of(context).colorScheme.surfaceContainer,
                            foregroundColor:
                                Theme.of(context).textTheme.bodyMedium?.color,
                            animationDuration: Duration(milliseconds: 200),
                            autoCloseDuration: Duration(milliseconds: 1300),
                            pauseOnHover: false,
                            type: ToastificationType.error);
                        return;
                      } else {
                        Database.addFolder(name: _controller.text);
                        context.read<AppData>().refreshAll();
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
