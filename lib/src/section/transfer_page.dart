import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:melonote/src/modules/socket.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transfer',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transfer Notes',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            const SizedBox(height: 16),
            btn(
              icon: Icons.upload,
              context: context,
              text: "Send",
              // Host and waiting for data
              onpressed: () {
                SocketClient().connect();
              },
            ),
            const SizedBox(height: 16),
            btn(
              icon: Icons.download,
              context: context,
              text: "Received",
              // Host and waiting for data
              onpressed: () {
                SocketServer().startServer();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget btn({
    required BuildContext context,
    onpressed,
    required String text,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 2,
            blurRadius: 16,
            offset: const Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(15)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withAlpha(175),
            Theme.of(context).colorScheme.primary
          ],
        ),
      ),
      child: TextButton.icon(
        onPressed: () => onpressed(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        label: Text(
          text,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 20.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        icon: Icon(
          icon,
          color: Colors.white,
          size: Theme.of(context).textTheme.headlineLarge?.fontSize,
        ),
      ),
    );
  }
}
