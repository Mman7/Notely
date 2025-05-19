import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/widget/folder.dart';

class FolderListView extends StatelessWidget {
  const FolderListView({super.key});
  @override
  Widget build(BuildContext context) {
    int checkScreen() {
      DeviceType deviceType =
          context.read<AppProvider>().getDeviceType(ScreenUtil().screenWidth);

      if (ScreenUtil().screenWidth > 1500) return 7;
      if (deviceType == DeviceType.mobile) return 2;
      if (deviceType == DeviceType.tablet) return 3;
      if (deviceType == DeviceType.windows) return 5;
      return 2;
    }

    //TODO implement this
    return Container(
      color: Colors.red,
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: checkScreen(),
          children: [Folder()],
        ),
      ),
    );
  }
}
