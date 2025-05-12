import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class Folder extends StatelessWidget {
  const Folder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Stack(children: [
        SvgPicture.asset(
          "assets/images/folder.svg",
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                'Folder 1',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
              Text('1 note',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w600)),
            ],
          ),
        )
      ]),
    );
  }
}
