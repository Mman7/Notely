import 'package:flutter/material.dart';
import 'package:syncnote/src/section/menu.dart';
import 'package:syncnote/src/section/notelist.dart';
import 'package:syncnote/src/section/noteview.dart';

void main() {
  runApp(const MainApp());
}

//TODO use fuzzy to search data

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.black,
          child: Row(
            children: [
              Flexible(fit: FlexFit.tight, flex: 2, child: Menu()),
              Flexible(fit: FlexFit.tight, flex: 3, child: NoteList()),
              Flexible(flex: 9, fit: FlexFit.tight, child: NoteView())
            ],
          ),
        ),
      ),
    );
  }
}
