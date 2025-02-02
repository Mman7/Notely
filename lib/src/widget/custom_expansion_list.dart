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
      required this.animationStatus,
      required this.setExpandedToggle,
      required this.isExpanded});

  final IconData icon;
  final String text;
  final bool isExpanded;
  final AnimationStatus animationStatus;
  final VoidCallback setExpandedToggle;
  final VoidCallback createBtnCallBack;
  final List list;

  @override
  Widget build(BuildContext context) {
    ////
    var expandedColumn = Column(
      children: [
        ListView.separated(
          separatorBuilder: (context, index) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1),
            child: Divider(),
          ),
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: ExpansionListItem(
                title: list[index].title,
              ),
            );
          },
        ),
        /////
        SizedBox(
          width: double.infinity,
          child: IconButton(
            onPressed: () => createBtnCallBack(),
            color: Colors.white,
            icon: const Icon(Icons.add_circle_outlined),
            style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ))),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: IconButton(
            style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ))),
            onPressed: () => setExpandedToggle(),
            icon: const Icon(Icons.arrow_drop_up),
            color: Colors.white,
          ),
        )
      ],
    );
    return Column(
      children: [
        CustomTextButton(
            icon: icon,
            text: text,
            btnColor: Colors.white,
            textColor: Colors.white,
            onPressed: () {
              context.read<AppProvider>().changeSidebarExtended(value: true);
              context
                  .read<AppProvider>()
                  .setListMode(value: text.replaceAll(' ', ''));
              setExpandedToggle();
            }),
        if (isExpanded && animationStatus == AnimationStatus.completed)
          expandedColumn
        else
          SizedBox(
            width: double.infinity,
            child: IconButton(
              style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ))),
              onPressed: () => setExpandedToggle(),
              icon: const Icon(Icons.arrow_drop_down),
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}
