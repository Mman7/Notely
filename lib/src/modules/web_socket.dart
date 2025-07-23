import 'dart:io';

import 'package:connectme/connectme.dart';

//TODO implement this in the main app
class WebSocketServer {
  WebSocketServer({required this.clientIp});
  String clientIp;
  Future<ConnectMeServer> startServer() async {
    final ConnectMeServer server = await ConnectMe.serve(
      InternetAddress.anyIPv4,
      port: 4040,
      onConnect: (ConnectMeClient client) {
        print('$clientIp connected.');
      },
      onDisconnect: (ConnectMeClient client) {
        print('$clientIp disconnected.');
      },
      onLog: (p0) => print(p0),
      type: ConnectMeType
          .ws, // by default, means using WebSocket server, can be also pure TCP
    );
    return server;
  }
}

class WebSocketClient {
  String serverAddress;
  WebSocketClient({required this.serverAddress});

  Future<ConnectMeClient> connect() async {
    final ConnectMeClient client =
        await ConnectMe.connect('ws://$serverAddress');
    // Listen for reverse String messages from the server.

    client.listen<String>((String message) {
      print('Client received: $message');
    });
    // client.send('Hello from client!');
    return client;
  }
}
