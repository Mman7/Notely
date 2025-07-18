import 'dart:async';
import 'dart:io';
import 'package:melonote/src/model/folder_model.dart';
import 'package:melonote/src/modules/local_database.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:melonote/src/modules/web_socket.dart';
// MAIN SOCKET

// Phone → UDP broadcast → “Hello, server?”
//
// Server → UDP reply → “I’m at 192.168.1.5:4040”
//
// Phone → TCP connect → 192.168.1.5:4040

class SocketClient {
  void connect() async {
    final udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    udpSocket.broadcastEnabled = true;
    final broadcastAddress = await getBroadcastAddress();
    final broadcastPort = 8888;
    udpSocket.send(
        'DISCOVER_SERVER'.codeUnits, broadcastAddress, broadcastPort);
    print('Broadcast message sent');

    udpSocket.listen((event) async {
      if (event == RawSocketEvent.read) {
        final datagram = udpSocket.receive();
        if (datagram == null) return;

        final message = String.fromCharCodes(datagram.data);
        print(
            'from Cli Received: $message from ${datagram.address.address}:${datagram.port}');

        if (message.startsWith('SERVER_HERE')) {
          final parts = message.split(':');
          final tcpPort = int.parse(parts[1]);
          final serverIp = datagram.address.address;
          print('from Cli Server found at $serverIp:$tcpPort');
          udpSocket.close();
          //TODO implement Data model and send it
          WebSocketClient(serverAddress: '$serverIp:$tcpPort')
              // WebSocketClient(serverAddress: '192.168.0.109:${4040}')
              .connect()
              .then((client) {
            // TODO implement this data
            List<FolderModel> notes = Database().getAllFolder();
            client.send('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
            // client.send('hey server im client');
          });
        }
      }
    });
  }
}

class SocketServer {
  String clientIp = '';
  startServer() async {
    /// Web Socket

    /// UDP
    final udpSocket =
        await RawDatagramSocket.bind(InternetAddress.anyIPv4, 8888);
    print('UDP server listening on port 8888');
    udpSocket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = udpSocket.receive();
        if (datagram == null) return;

        final message = String.fromCharCodes(datagram.data);
        clientIp = datagram.address.address;
        print(
            'from Serv Received: $message from ${datagram.address.address}:${datagram.port}');

        if (message == 'DISCOVER_SERVER') {
          // setup server
          WebSocketServer(clientIp: clientIp).startServer().then((server) {
            server.listen<String>((data, client) {
              print('Server received: $data');
              client.send('FUCK YOU NI');
            });
          });
          final response = 'SERVER_HERE:4040'; // include TCP port
          udpSocket.send(response.codeUnits, datagram.address, datagram.port);

          print(
              'from Serv Sent response to ${datagram.address.address}:${datagram.port}');
        }
      }
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
  print('Calculated broadcast address: $broadcastIp');

  return InternetAddress(broadcastIp);
}
