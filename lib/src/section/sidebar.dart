import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:syncnote/src/provider/app_provider.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
    required this.sidebarXController,
  });

  final SidebarXController sidebarXController;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: sidebarXController,
      items: [
        SidebarXItem(
            icon: Icons.search,
            label: ' Search',
            onTap: () => sidebarXController.setExtended(true)),
        SidebarXItem(
            icon: Icons.add_circle_rounded,
            label: ' New Note',
            selectable: false,
            onTap: () {
              context.read<AppProvider>().setNoteSelected(id: 0);
            }),
        const SidebarXItem(icon: Icons.star, label: ' Bookmark'),
        const SidebarXItem(icon: Icons.book, label: ' All Notes'),
        const SidebarXItem(icon: Icons.menu_book, label: ' Notebooks'),
        const SidebarXItem(icon: Icons.bookmark, label: ' Tags'),
      ],
    );
  }
}
