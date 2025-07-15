import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:melonote/src/model/note_model.dart';
import 'package:melonote/src/provider/app_provider.dart';
import 'package:melonote/src/section/editor.dart';
import 'package:melonote/src/section/note_list.dart';
import 'package:provider/provider.dart';

class SideBar extends StatefulWidget {
  const SideBar({
    super.key,
  });
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  TextEditingController textEditController = TextEditingController();
  String text = '';
  @override
  void dispose() {
    textEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: HexColor('#211C3A'), border: null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                context.read<AppProvider>().setPageIndex(0);
              },
              icon: Icon(
                Icons.home,
                color: Colors.white,
                size: Theme.of(context).textTheme.headlineSmall?.fontSize,
              ),
              label: Text(
                'MeloNote',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.sp,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
          Gap(15),
          btn(
              isNewNoteBtn: false,
              context: context,
              text: 'Search',
              icon: Icons.search,
              onpressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteList(
                      isSearching: true,
                    ),
                  ),
                );
              }),
          Gap(20),
          btn(
            isNewNoteBtn: true,
            text: 'New Note',
            icon: Icons.add,
            context: context,
            onpressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Editor(
                    note: Note.newNote(),
                    isNew: true,
                  ),
                ),
              );
            },
          ),
          Expanded(child: Container()),
          btnStyless(
              context: context,
              icon: Icons.ios_share,
              text: 'Share',
              onpressed: () {
                context.read<AppProvider>().setPageIndex(2);
              }),
          btnStyless(
              context: context,
              icon: Icons.settings,
              text: 'Settings',
              onpressed: () {
                context.read<AppProvider>().setPageIndex(3);
              }),
        ],
      ),
    );
  }

  SizedBox btnStyless(
      {required BuildContext context,
      required String text,
      required IconData icon,
      required VoidCallback onpressed}) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () => onpressed(),
        icon: Icon(
          icon,
          color: Colors.white,
          size: Theme.of(context).textTheme.headlineSmall?.fontSize,
        ),
        label: Text(
          text,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 20.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        ),
      ),
    );
  }

  SizedBox btn(
      {required BuildContext context,
      onpressed,
      required String text,
      required IconData icon,
      required bool isNewNoteBtn}) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              if (isNewNoteBtn)
                BoxShadow(
                  color: Theme.of(context).primaryColor.withAlpha(255),
                  spreadRadius: 2,
                  blurRadius: 21,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: TextButton.icon(
            onPressed: () => onpressed(),
            style: TextButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            label: Text(
              text,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            icon: Icon(
              icon,
              color: Colors.white,
              size: Theme.of(context).textTheme.headlineSmall?.fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
