import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';

class ExpansionListItem extends StatelessWidget {
  const ExpansionListItem({super.key, required this.title});
  final String title;
  //TODO style this
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          )),
      onPressed: () {
        context.read<AppProvider>().setNoteBookSelect(value: title);
      },
      child: Text(
        title,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
