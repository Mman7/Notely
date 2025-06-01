import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/section/note_list.dart';

class Folder extends StatelessWidget {
  const Folder({super.key, this.folderName, this.folderCount});
  final String? folderName;
  final int? folderCount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoteList()),
        );
      },
      child: Center(
        child: Stack(alignment: Alignment.centerLeft, children: [
          SvgPicture.asset(
            "assets/images/folder.svg",
          ),
          Container(
            margin: EdgeInsets.only(
              left: 20.sp,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Icon(
                    Icons.file_copy_sharp,
                    size: 20.sp,
                  ),
                ),
                Gap(10),
                Text(
                  folderName ?? 'Unorganized',
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 16.5, fontWeight: FontWeight.w700),
                ),
                Text(
                    '${folderCount ?? context.watch<AppProvider>().noteList.length} note',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[400])),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
