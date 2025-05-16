import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/myobjectbox.dart';
import 'package:syncnote/src/model/notebooks_model.dart';
import 'package:syncnote/src/provider/app_provider.dart';

class SideBar extends StatefulWidget {
  const SideBar({
    super.key,
  });
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool noteBookisExpanded = false;
  bool tagsIsExpanded = false;
  TextEditingController textEditController = TextEditingController();
  String text = '';
  @override
  void dispose() {
    textEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isExtended = context.watch<AppProvider>().isSidebarExtended;

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
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30.sp,
              ),
            ),
            Gap(40),
            TextField(
              onChanged: (value) {
                setState(() {
                  text = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for notes',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Gap(20),
            SizedBox(
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
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    label: Text(
                      'New Note',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
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
            ),
            // SizedBox(
            //   width: double.infinity,
            //   child: Material(
            //       color: Colors.transparent,
            //       child: InkWell(
            //           onTap: () {
            //             // close note book expand
            //             setNoteBookExpanded(value: false);
            //             if (appProvider.isSidebarExtended) {
            //               appProvider.changeSidebarExtended();
            //             } else {
            //               appProvider.changeSidebarExtended();
            //             }
            //           },
            //           child: Icon(
            //             openIcon(),
            //             color: Colors.white,
            //           ))),
            // ),
          ],
        ),
      ),
    );
  }

  void showCreateNoteBookDialog(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => SimpleDialog(children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                width: ScreenUtil().screenWidth / 3,
                height: ScreenUtil().screenHeight / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextField(
                      controller: textEditController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                            label: const Text('Create'),
                            onPressed: () {
                              final editorText = textEditController.text;
                              if (editorText.isEmpty) return;
                              final noteBookBox =
                                  objectbox.store.box<Notebook>();
                              noteBookBox.put(Notebook(title: editorText));
                              Navigator.of(context).pop();
                              context.read<AppProvider>().refreshNoteBook();
                            },
                            icon: const Icon(Icons.check_circle)),
                        TextButton.icon(
                            label: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              textEditController.clear();
                            },
                            icon: const Icon(Icons.highlight_remove)),
                      ],
                    )
                  ],
                ),
              ),
            ]));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }
}
