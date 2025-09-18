import 'dart:io';
import 'package:connectme/connectme.dart';
import 'package:flutter/material.dart';

class WebSocketServer {
  Future<ConnectMeServer> startServer() async {
    try {
      final ConnectMeServer server = await ConnectMe.serve(
        InternetAddress.anyIPv4,
        port: 4040,
        onConnect: (ConnectMeClient client) {
          debugPrint('someone connected WS.');
        },
        onDisconnect: (ConnectMeClient client) {
          debugPrint('someone disconnected from WS.');
        },
        onLog: (p0) => debugPrint(p0),
        type: ConnectMeType.ws,
      );
      return server;
    } catch (e) {
      throw Error();
    }
  }
}

class WebSocketClient {
  String serverAddress;
  WebSocketClient({required this.serverAddress});

  Future<ConnectMeClient> connect() async {
    final ConnectMeClient client =
        await ConnectMe.connect('ws://$serverAddress');
    // await ConnectMe.connect('$serverAddress');
    return client;
  }
}
