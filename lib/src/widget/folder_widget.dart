import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:notely/src/provider/app_status.dart';
import 'package:provider/provider.dart';

class FolderWidget extends StatefulWidget {
  const FolderWidget({
    super.key,
    required this.folderTitle,
    required this.folderCount,
  });

  final String folderTitle;
  final int folderCount;

  @override
  State<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    bool isDarkmode = context.read<AppStatus>().isDarkMode;
    return MouseRegion(
      onEnter: (value) {
        setState(() => isHover = true);
      },
      onExit: (event) => setState(() => isHover = false),
      child: LayoutBuilder(builder: (context, constraints) {
        double parentWidth = constraints.maxWidth;

        double fontSize = parentWidth * 0.15; //
        return Stack(alignment: Alignment.centerLeft, children: [
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: const Color(0x319E9E9E).withAlpha(20),
                offset: Offset(0, 0),
                spreadRadius: 1,
                blurRadius: 20,
              )
            ]),
            child: SvgPicture.asset(
              isDarkmode
                  ? "assets/images/dark_folder.svg"
                  : "assets/images/folder.svg",
              height: 150.sp,
              colorFilter: isHover
                  ? ColorFilter.mode(Colors.white24, BlendMode.srcATop)
                  : ColorFilter.mode(Colors.transparent, BlendMode.color),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fontSize * 0.75),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(fontSize * 0.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).primaryColor.withAlpha(100),
                  ),
                  child: Icon(
                    color: Theme.of(context).colorScheme.surfaceBright,
                    size: fontSize * 1.1,
                    Icons.file_copy_sharp,
                  ),
                ),
                Gap(10),
                Text(
                  widget.folderTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: fontSize * 0.75, fontWeight: FontWeight.w700),
                ),
                Text('${widget.folderCount} note',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.grey,
                          fontSize: fontSize * 0.6,
                          fontWeight: FontWeight.w700,
                        )),
              ],
            ),
          )
        ]);
      }),
    );
  }
}
