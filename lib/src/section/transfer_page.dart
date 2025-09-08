import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:notely/src/modules/socket.dart';
import 'package:notely/src/provider/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  bool isHosting = false;
  bool isWaiting = false;
  Completer completer = Completer<String>();

  resetCompleter() {
    setState(() {
      completer = Completer<String>();
    });
  }

  popupWaiting() {
    if (isWaiting) {
      showDialog(
        context: context,
        // if dev set this to true the dialog will not close when click outside
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingAnimationWidget.waveDots(
                color:
                    Theme.of(context).textTheme.bodyLarge?.color ?? Colors.blue,
                size: 40.w,
              ),
              SizedBox(height: 16.h),
              Text(
                'Waiting for connection...',
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isWaiting = false;
                });
                SocketServer().stopServer(completer);
                resetCompleter();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

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
              onpressed: () {
                SocketClient().connect();
              },
            ),
            const SizedBox(height: 16),
            Divider(
              color: Colors.grey.withAlpha(50),
            ),
            const SizedBox(height: 16),
            btn(
                icon: Icons.download,
                context: context,
                text: "Received",
                // Host and waiting for data
                onpressed: () async {
                  setState(() {
                    isWaiting = true;
                  });
                  SocketServer().startServer(() {
                    Navigator.of(context).pop();
                    setState(() {
                      isWaiting = false;
                    });
                    completer.complete('Data received and applied');
                    resetCompleter();
                  });
                  popupWaiting();
                  final state = await completer.future;
                  if (state == 'Data received and applied') {
                    if (context.mounted) {
                      context.read<AppProvider>().refreshAll();
                      toastification.show(
                          style: ToastificationStyle.minimal,
                          primaryColor: Colors.lightGreen,
                          icon: Icon(Icons.done),
                          context:
                              context, // optional if you use ToastificationWrapper
                          title: Text('Your folder has been created'),
                          pauseOnHover: false,
                          autoCloseDuration: const Duration(seconds: 2));
                    }
                  }
                }),
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
        color: Theme.of(context).textTheme.bodyLarge?.color,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: TextButton.icon(
        onPressed: () => onpressed(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        ),
        label: Text(
          text,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 20.sp,
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.w600,
              ),
        ),
        icon: Icon(
          icon,
          color: Theme.of(context).colorScheme.surface,
          size: Theme.of(context).textTheme.headlineLarge?.fontSize,
        ),
      ),
    );
  }
}
