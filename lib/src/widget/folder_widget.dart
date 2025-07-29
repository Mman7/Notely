import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class FolderWidget extends StatelessWidget {
  const FolderWidget({
    super.key,
    required this.folderTitle,
    required this.folderCount,
  });

  final String folderTitle;
  final int folderCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double parentWidth = constraints.maxWidth;

      double fontSize = parentWidth * 0.15; //
      return Stack(alignment: Alignment.centerLeft, children: [
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(50, 158, 158, 158),
              offset: Offset(0, 0),
              spreadRadius: 1,
              blurRadius: 20,
            )
          ]),
          child: SvgPicture.asset(
            "assets/images/folder.svg",
            height: 150.sp,
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
                  color: Theme.of(context).colorScheme.surface,
                  size: fontSize * 1.1,
                  Icons.file_copy_sharp,
                ),
              ),
              Gap(10),
              Text(
                folderTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        Theme.of(context).colorScheme.secondary.withAlpha(200),
                    fontSize: fontSize * 0.75,
                    fontWeight: FontWeight.w800),
              ),
              Text('$folderCount note',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: fontSize * 0.6,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withAlpha(100))),
            ],
          ),
        )
      ]);
    });
  }
}
