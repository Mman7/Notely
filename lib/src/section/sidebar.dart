import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:notely/src/model/note_model.dart';
import 'package:notely/src/provider/app_status.dart';
import 'package:notely/src/section/editor.dart';
import 'package:notely/src/section/note_list.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        surfaceTintColor: Theme.of(context).colorScheme.tertiary,
        shape: Border.all(color: Theme.of(context).colorScheme.tertiary),
        toolbarHeight: 65,
        centerTitle: true,
        title: ListTile(
          leading: Icon(
            Icons.home,
            color: Theme.of(context).textTheme.headlineLarge?.color,
            size: Theme.of(context).textTheme.headlineLarge?.fontSize,
          ),
          title: Text(
            'Notely',
            style: TextStyle(
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontWeight: FontWeight.bold,
              fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.tertiary,
          ),
          color: Theme.of(context).colorScheme.tertiary,
        ),
        child: Column(
          children: [
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
                icon: Icons.folder,
                text: 'All Folder',
                onpressed: () {
                  context.read<AppStatus>().setPageIndex(0);
                }),
            btnStyless(
                context: context,
                icon: Icons.ios_share,
                text: 'Share',
                onpressed: () {
                  context.read<AppStatus>().setPageIndex(2);
                }),
            btnStyless(
                context: context,
                icon: Icons.settings,
                text: 'Settings',
                onpressed: () {
                  context.read<AppStatus>().setPageIndex(3);
                }),
          ],
        ),
      ),
    );
  }

  Widget btnStyless(
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
          color: Theme.of(context).textTheme.headlineSmall?.color,
          size: 20.sp,
        ),
        label: Text(
          text,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 20.sp,
                color: Theme.of(context).textTheme.headlineSmall?.color,
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
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              if (isNewNoteBtn)
                BoxShadow(
                  color: Theme.of(context).primaryColor.withAlpha(175),
                  spreadRadius: 2,
                  blurRadius: 16,
                  offset: const Offset(0, 0),
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
                    fontSize:
                        Theme.of(context).textTheme.headlineSmall?.fontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            icon: Icon(
              icon,
              color: Colors.white,
              size: Theme.of(context).textTheme.headlineLarge?.fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
