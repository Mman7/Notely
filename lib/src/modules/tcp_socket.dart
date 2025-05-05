import 'dart:io';

import 'package:connectme/connectme.dart';

class TCPServer {
  void startServer() async {
    final ConnectMeServer server = await ConnectMe.serve(
      InternetAddress.anyIPv4,
      port: 4040,
      onConnect: (ConnectMeClient client) {
        print('${client.headers} connected.');
        client.send('im server');
      },
      onDisconnect: (ConnectMeClient client) {
        print('${client.headers.entries} disconnected.');
      },
      onLog: (p0) => print(p0),
      type: ConnectMeType
          .ws, // by default, means using WebSocket server, can be also pure TCP
    );
    server.listen<String>((data, client) {
      print('Server received: $data');
    });
  }
}

class TCPClient {
  String serverAddress;
  TCPClient({required this.serverAddress});

  Future<ConnectMeClient> connect() async {
    final ConnectMeClient client =
        await ConnectMe.connect('ws://$serverAddress');

    // Listen for reverse String messages from the server.
    client.listen<String>((String message) {
      print('Client received: $message');
    });
    return client;
  }
}
