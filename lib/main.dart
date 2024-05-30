import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/section/menu.dart';
import 'package:syncnote/src/section/notelist.dart';
import 'package:syncnote/src/section/noteview.dart';
import 'package:syncnote/src/utils/myobjectbox.dart';
import 'myobjectbox.dart';

//TODO use fuzzy to search data

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();
  runApp(ChangeNotifierProvider(
    create: (ctx) => AppProvider(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.black,
          child: const Row(
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
