import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/myobjectbox.dart';
import 'package:syncnote/src/model/mode_model.dart';
import 'package:syncnote/src/model/notebooks_model.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/widget/custom_expansion_list.dart';
import 'package:syncnote/src/widget/custom_text_button.dart';

import '../modules/socket.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key, required this.aniContoller});
  final AnimationController aniContoller;
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool noteBookisExpanded = false;
  bool tagsIsExpanded = false;
  TextEditingController textEditController = TextEditingController();

  @override
  void dispose() {
    textEditController.dispose();
    super.dispose();
  }

  setNoteBookExpanded({required bool value}) {
    setState(() {
      noteBookisExpanded = value;
    });
  }

  setTagsExpanded({required bool value}) {
    setState(() {
      tagsIsExpanded = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isExtended = context.watch<AppProvider>().isSidebarExtended;
    var appProvider = context.read<AppProvider>();

    openIcon() {
      return isExtended
          ? Icons.keyboard_arrow_left_sharp
          : Icons.keyboard_arrow_right_sharp;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: hexToColor('#313866'), border: null),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextButton(
                icon: Icons.search,
                text: ' Search',
                btnColor: Colors.white,
                textColor: Colors.white,
                onPressed: () {
                  appProvider.setListMode(value: Mode.search);
                  appProvider.clearNoteBookSelect();
                  appProvider.setSearchMode(value: true);
                },
              ),
              CustomTextButton(
                bgColor: hexToColor('#50409A'),
                btnColor: Colors.white,
                textColor: Colors.white,
                margin: const EdgeInsets.all(3),
                borderRadiusValue: BorderRadius.circular(8.5),
                icon: Icons.add_circle_rounded,
                text: ' New Note',
                onPressed: () {
                  appProvider.setSearchMode(value: false);
                  appProvider.clearNoteBookSelect();
                  appProvider.setNoteSelected(id: 0);
                },
              ),
              CustomTextButton(
                icon: Icons.book,
                btnColor: Colors.white,
                textColor: Colors.white,
                text: ' All Notes',
                onPressed: () {
                  appProvider.setSearchMode(value: false);
                  appProvider.setListMode(value: Mode.allnotes);
                  appProvider.clearNoteBookSelect();
                },
              ),
              CustomTextButton(
                icon: Icons.bookmark,
                btnColor: Colors.white,
                textColor: Colors.white,
                text: ' Bookmarks',
                onPressed: () {
                  appProvider.setListMode(value: Mode.bookmarks);
                  appProvider.clearNoteBookSelect();
                },
              ),
              // Notebook Button
              Container(
                color: Colors.black12,
                child: CustomExpansionList(
                  animationStatus: widget.aniContoller.status,
                  setExpandedToggle: () {
                    setNoteBookExpanded(value: !noteBookisExpanded);
                    appProvider.changeSidebarExtended(value: true);
                  },
                  list: context.watch<AppProvider>().noteBooks,
                  createBtnCallBack: () => showCreateNoteBookDialog(context),
                  isExpanded: noteBookisExpanded,
                  icon: Icons.menu_book,
                  text: ' Notebooks',
                ),
              ),
            ],
          ),

          // close expanded button
          Column(
            children: [
              // transfer Buton
              IconButton(
                onPressed: () {
                  SocketService().sendMsg();
                },
                icon: Icon(Icons.directions_bike_outlined),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  SocketService().startSocket();
                },
                icon: Icon(Icons.screen_share),
                color: Colors.white,
              ),
              SizedBox(
                width: double.infinity,
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () {
                          // close note book expand
                          setNoteBookExpanded(value: false);
                          if (appProvider.isSidebarExtended) {
                            appProvider.changeSidebarExtended();
                          } else {
                            appProvider.changeSidebarExtended();
                          }
                        },
                        child: Icon(
                          openIcon(),
                          color: Colors.white,
                        ))),
              ),
            ],
          )
        ],
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
}
