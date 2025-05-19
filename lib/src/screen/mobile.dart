import 'package:flutter/material.dart';
import 'package:syncnote/src/section/folder_list_view.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Column(
          children: [FolderListView()],
        ),
      ),
    );
  }
}
