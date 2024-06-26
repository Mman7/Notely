import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncnote/src/section/notelist.dart';
import 'package:syncnote/src/section/noteview.dart';
import 'package:syncnote/src/section/sidebar.dart';

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _animation = IntTween(begin: 80, end: 200).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _animation.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: _animation.value,
          child: SideBar(aniContoller: _animationController),
        ),
        const Flexible(flex: 500, child: NoteList()),
        const Flexible(flex: 1000, child: NoteView())
      ],
    );
  }
}
