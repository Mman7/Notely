import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/model/folder_model.dart';
import 'package:syncnote/src/modules/local_database.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/widget/folder.dart';

class FolderListView extends StatelessWidget {
  FolderListView({super.key});
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<FolderModel> folderList = context.watch<AppProvider>().folderList;

    int checkScreen() {
      DeviceType deviceType = context.read<AppProvider>().getDeviceType();
      if (ScreenUtil().screenWidth > 1500) return 7;
      if (deviceType == DeviceType.mobile) return 2;
      if (deviceType == DeviceType.tablet) return 3;
      if (deviceType == DeviceType.windows) return 5;
      return 2;
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: SizedBox(
        height: ScreenUtil().screenHeight * 0.85,
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: checkScreen(),
              mainAxisSpacing: 5,
              crossAxisSpacing: 15,
            ),
            itemCount: folderList.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Folder();
              }
              // if index is not folderlist last index
              if (index != folderList.length + 1) {
                return Folder(
                  id: folderList[index - 1].id,
                  noteIncluded: folderList[index - 1].getConvertNoteInclude(),
                  folderCount:
                      folderList[index - 1].getConvertNoteInclude().length,
                  folderName: folderList[index - 1].title,
                );
              }

              return addNewFolderView(context);
            }),
      ),
    );
  }

  Container addNewFolderView(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
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
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Database().addNoteBook(name: _controller.text);
                      context.read<AppProvider>().refresh();
                      _controller.text = '';
                      Navigator.of(context).pop();
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
            size: 30,
          ),
        ),
      ),
    );
  }
}
