import 'package:flutter/material.dart';
import 'package:melonote/src/modules/socket.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transfer Notes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              // Send Data
              onPressed: () {
                SocketClient().connect();
              },
              child: const Text('Send'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              // Host and waiting for data
              onPressed: () {
                SocketServer().startServer();
              },
              child: const Text('Receive'),
            ),
          ],
        ),
      ),
    );
  }
}
