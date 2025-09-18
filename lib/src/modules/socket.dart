import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectme/connectme.dart';
import 'package:flutter/material.dart';
import 'package:notely/main.dart';
import 'package:notely/src/model/folder_model.dart';
import 'package:notely/src/model/note_model.dart';
import 'package:notely/src/modules/encrypt.dart';
import 'package:notely/src/modules/local_database.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:notely/src/modules/web_socket.dart';
import 'package:notely/src/provider/app_data.dart';
import 'package:provider/provider.dart';

import 'package:uuid/uuid.dart';

String randomId = Uuid().v4();
bool isHosting = false;

// MAIN SOCKET

// Phone → UDP broadcast → “Hello, server?”
//
// Server → UDP reply → “I’m at 192.168.1.5:4040”
//
// Phone → TCP connect → 192.168.1.5:4040

class SocketClient {
  static final context = navigatorKey.currentContext as BuildContext;
  static _connectWithTcp({serverIp, tcpPort}) {
    WebSocketClient(serverAddress: '$serverIp:$tcpPort')
        .connect()
        .then((client) async {
      client.send(AES256GCM.encrypt(plaintext: await getLocalData()));
      client.listen<String>((data) {
        // client.close();
        handleData(data, context);
        Database.clearDeletedList();
      });
    });
  }

  static void connect() async {
    final udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    udpSocket.broadcastEnabled = true;
    final broadcastAddress = await getBroadcastAddress();
    final broadcastPort = 8888;
    udpSocket.send(
        'DISCOVER_SERVER'.codeUnits, broadcastAddress, broadcastPort);

    udpSocket.listen((event) async {
      if (event == RawSocketEvent.read) {
        final datagram = udpSocket.receive();
        if (datagram == null) return;
        final message = String.fromCharCodes(datagram.data);
        debugPrint(
            'Received UDP message: $message from ${datagram.address}:${datagram.port}');
        if (message.startsWith('SERVER_HERE')) {
          final parts = message.split(':');
          final tcpPort = int.parse(parts[1]);
          final serverIp = datagram.address.address;
          _connectWithTcp(serverIp: serverIp, tcpPort: tcpPort);
        }
      }
    });
  }
}

// Handle incoming data
void handleData(data, BuildContext context) async {
  debugPrint('data received');
  dynamic decodedData = jsonDecode(AES256GCM.decrypt(base64Cipher: data));
  dynamic foldersAndNotes = decodedData['data'];
  List<String> deletedList = List<String>.from(decodedData['deletedList']);

  if (decodedData['uid'] == randomId) {
    debugPrint('Ignoring own sync data');
    return;
  }

  if (decodedData['type'] == 'sync') {
    List<Note> notes = [];
    for (var i = 0; i <= foldersAndNotes['notes'].length - 1; i++) {
      dynamic noteFromData = foldersAndNotes['notes'][i];
      Note note = Note(
          content: noteFromData['content'],
          title: noteFromData['title'],
          previewContent: noteFromData['previewContent'],
          uuid: noteFromData['uuid'],
          dateCreated: DateTime.parse(
              noteFromData['dateCreated'] ?? DateTime.now().toIso8601String()),
          lastestModified: DateTime.parse(noteFromData['lastestModified'] ??
              DateTime.now().toIso8601String()));
      notes.add(note);
    }
    List<FolderModel> folders = [];
    for (var i = 0; i <= foldersAndNotes['folders'].length - 1; i++) {
      dynamic folderFromData = foldersAndNotes['folders'][i];
      FolderModel folder = FolderModel(
        uuid: folderFromData['uuid'],
        title: folderFromData['title'],
        noteInclude: folderFromData['noteInclude'],
      );
      folders.add(folder);
    }
    Database.applyDatas(notesFromRemote: notes, remoteFolders: folders);
    Database.removeNotesByUUIDs(deletedList);
    context.read<AppData>().refreshAll();
  }
}

Future<String> getLocalData() async {
  List<FolderModel> folders = Database.getAllFolder();
  List<Note> notes = Database.getAllNote();
  List<String> deletedList = await Database.getDeletedNoteList();

  String data = jsonEncode({
    'type': 'sync',
    'uid': randomId,
    'deletedList': deletedList,
    'data': {'folders': folders, 'notes': notes},
  });

  return data;
}

class SocketServer {
  static late ConnectMeServer wsServer;
  static late RawDatagramSocket udpServer;

  static stopServer(
    Completer completer,
  ) async {
    await wsServer.close();
    stopUDPServer();
    isHosting = false;
    completer.complete('Server stopped by user');
    debugPrint('Server stopped');
  }

  static stopUDPServer() {
    udpServer.close();
  }

  // Start UDP server to listen for discovery messages and TCP server for connections
  static startServer({callback}) async {
    /// UDP
    if (isHosting) return;
    final udpSocket =
        await RawDatagramSocket.bind(InternetAddress.anyIPv4, 8888);
    debugPrint('UDP server listening on port 8888');
    udpServer = udpSocket;
    udpSocket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = udpSocket.receive();
        // Ignore if packet comes from this device
        if (datagram == null) return;
        final message = String.fromCharCodes(datagram.data);

        if (message == 'DISCOVER_SERVER') {
          final response = 'SERVER_HERE:4040'; // include TCP port
          udpSocket.send(response.codeUnits, datagram.address, datagram.port);
        }
      }
    });
    // WS
    _startTCPserver(
      callback: callback,
    );
  }

  static _startTCPserver({callback}) async {
    final context = navigatorKey.currentContext as BuildContext;
    await WebSocketServer().startServer().then((server) {
      wsServer = server;
      isHosting = true;
      server.listen<String>((data, client) async {
        handleData(data, context);
        client.send(AES256GCM.encrypt(plaintext: await getLocalData()));
        if (callback != null) callback();
        // client.close();
        // server.close();
      });
    });
  }
}

Future<InternetAddress> getBroadcastAddress() async {
  final info = NetworkInfo();
  final localIp = await info.getWifiIP();
  final subnetMask = await info.getWifiSubmask();
  if (localIp == null || subnetMask == null) {
    throw Exception('Could not get local IP or subnet mask');
  }

  final ipParts = localIp.split('.').map(int.parse).toList();
  final maskParts = subnetMask.split('.').map(int.parse).toList();

  final broadcastParts =
      List.generate(4, (i) => ipParts[i] | (~maskParts[i] & 0xFF));
  final broadcastIp = broadcastParts.join('.');

  return InternetAddress(broadcastIp);
}
