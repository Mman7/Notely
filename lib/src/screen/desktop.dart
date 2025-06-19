import 'package:flutter/material.dart';
import 'package:melonote/src/section/folder_list_view.dart';
import 'package:melonote/src/section/header.dart';
import 'package:melonote/src/section/sidebar.dart';

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: SideBar(),
        ),
        Flexible(
            flex: 9,
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                children: [
                  Expanded(flex: 1, child: Header()),
                  Expanded(flex: 8, child: FolderListView())
                ],
              ),
            )),
      ],
    );
  }
}
