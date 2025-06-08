import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/section/editor.dart';

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
      width: double.infinity,
      decoration: BoxDecoration(color: hexToColor('#211C3A'), border: null),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(10),
            Text(
              'MeloNote',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30.sp,
              ),
            ),
            Gap(15),
            TextField(
              onChanged: (value) {
                setState(() {
                  text = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for notes',
                hintStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            Gap(20),
            newNoteBtn(context),
          ],
        ),
      ),
    );
  }

  SizedBox newNoteBtn(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withAlpha(255),
            spreadRadius: 2,
            blurRadius: 21,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ]),
        child: TextButton.icon(
            onPressed: () {
              // Navigate to the editor page
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
            style: TextButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            label: Text(
              'New Note',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: Theme.of(context).textTheme.headlineSmall?.fontSize,
            )),
      ),
    );
  }
}
