import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/myobjectbox.dart';
import 'package:syncnote/src/model/mode_model.dart';
import 'package:syncnote/src/model/notebooks_model.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/widget/custom_expansion_list.dart';
import 'package:syncnote/src/widget/custom_text_button.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

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
      decoration: const BoxDecoration(color: Colors.white, border: null),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextButton(
                icon: Icons.search,
                text: ' Search',
                onPressed: () {
                  appProvider.setListMode(value: Mode.search);
                  appProvider.clearNoteBookSelect();
                  appProvider.setSearchMode(value: true);
                },
              ),
              CustomTextButton(
                bgColor: Colors.redAccent,
                btnColor: Colors.white,
                textColor: Colors.white,
                margin: const EdgeInsets.all(7.5),
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
                text: ' All Notes',
                onPressed: () {
                  appProvider.setSearchMode(value: false);
                  appProvider.setListMode(value: Mode.allnotes);
                  appProvider.clearNoteBookSelect();
                },
              ),
              CustomTextButton(
                icon: Icons.bookmark,
                text: ' Bookmarks',
                onPressed: () {
                  appProvider.setListMode(value: Mode.bookmarks);
                  appProvider.clearNoteBookSelect();
                },
              ),

              //add colour
              CustomExpansionList(
                setExpandedToggle: () {
                  setNoteBookExpanded(value: !noteBookisExpanded);
                  appProvider.clearNoteBookSelect();
                },
                list: context.watch<AppProvider>().noteBooks,
                createBtnCallBack: () => showD(context),
                isExpanded: noteBookisExpanded,
                icon: Icons.menu_book,
                text: ' Notebooks',
              ),
            ],
          ),

          // close expanded button
          SizedBox(
            width: double.infinity,
            child: Material(
                child: InkWell(
                    onTap: () {
                      context.read<AppProvider>().changeSidebarExtended();
                      setNoteBookExpanded(value: false);
                      setTagsExpanded(value: false);
                    },
                    child: Icon(openIcon()))),
          )
        ],
      ),
    );
  }

  void showD(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                width: ScreenUtil().screenWidth / 2,
                height: ScreenUtil().screenHeight / 2,
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
