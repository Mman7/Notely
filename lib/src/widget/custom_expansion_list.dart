import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/widget/custom_list_item.dart';
import 'package:syncnote/src/widget/custom_text_button.dart';

class CustomExpansionList extends StatelessWidget {
  const CustomExpansionList(
      {super.key,
      required this.list,
      required this.createBtnCallBack,
      required this.icon,
      required this.text,
      required this.setToggle,
      required this.isExpanded});

  final IconData icon;
  final String text;
  final bool isExpanded;
  final VoidCallback setToggle;
  final VoidCallback createBtnCallBack;
  final List list;

  @override
  Widget build(BuildContext context) {
    //TODO get notebooks
    return Container(
      color: Colors.green,
      child: Column(children: [
        CustomTextButton(
            icon: icon,
            text: text,
            onPressed: () {
              context.read<AppProvider>().changeSidebarExtended(value: true);
              setToggle();
            }),
        isExpanded
            ? Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListItem();
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: IconButton(
                      onPressed: () => createBtnCallBack(),
                      icon: Icon(Icons.add_circle_outlined),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ))),
                    ),
                  )
                ],
              )
            : Container()
      ]),
    );
  }
}
