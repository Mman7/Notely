import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncnote/src/modules/socket.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});
//TODO implement mobile page
//TODO buld mobile apk

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            color: Colors.orange,
            child: TextButton(
                onPressed: () {
                  SocketService().startSocket();
                },
                child: Text('start server'))),
        Container(
            color: Colors.orange,
            child: TextButton(
                onPressed: () {
                  SocketService().sendMsg();
                },
                child: Text('Connect server'))),
      ],
    );
  }
}
