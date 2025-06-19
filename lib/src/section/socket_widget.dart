import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:melonote/src/modules/socket.dart';

class SocketWidget extends StatelessWidget {
  const SocketWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenwidth = ScreenUtil().screenWidth;
    final screenHeight = ScreenUtil().screenHeight;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      margin: EdgeInsets.symmetric(
          horizontal: screenwidth / 3, vertical: screenHeight / 3),
      child: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SocketButton(
            onClick: () {
              SocketClient().connect();
            },
            text: 'Send',
            icon: Icons.send,
          ),
          SocketButton(
            onClick: () {
              SocketServer().startServer();
            },
            text: 'Receive',
            icon: Icons.download_for_offline_outlined,
          ),
        ]),
      ),
    );
  }
}

class SocketButton extends StatelessWidget {
  const SocketButton({
    required this.text,
    required this.icon,
    required this.onClick,
    super.key,
  });
  final String text;
  final IconData icon;
  final VoidCallback onClick;
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(25),
        iconSize: 30,
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(50),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: onClick,
      label: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
      icon: Icon(icon),
    );
  }
}
