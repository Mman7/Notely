import 'dart:async';
import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';

// users need to let this app pass through "public network"
// working now

// Phone → UDP broadcast → “Hello, server?”
//
// Server → UDP reply → “I’m at 192.168.1.5:4040”
//
// Phone → TCP connect → 192.168.1.5:4040

class SocketClient {
  void printE() async {
    final localIp = await NetworkInfo().getWifiIP();
    print(localIp);
    final udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    udpSocket.broadcastEnabled = true;

    final broadcastAddress = await getBroadcastAddress();
    final broadcastPort = 8888;

    udpSocket.send(
        'DISCOVER_SERVER'.codeUnits, broadcastAddress, broadcastPort);
    print('Broadcast message sent');

    final completer = Completer<String>();

    udpSocket.listen((event) {
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
          completer.complete('$serverIp:$tcpPort');
          udpSocket.close();
        }
      }
    });

    final serverAddress = await completer.future;
    print('Connecting to server at $serverAddress');
// TODO implement TCP
    // Here you can add TCP connection logic using Socket.connect
  }
}

class SocketService {
  main() async {
    final udpSocket =
        await RawDatagramSocket.bind(InternetAddress.anyIPv4, 8888);
    print('UDP server listening on port 8888');

    udpSocket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = udpSocket.receive();
        if (datagram == null) return;

        final message = String.fromCharCodes(datagram.data);
        print(
            'from Serv Received: $message from ${datagram.address.address}:${datagram.port}');

        if (message == 'DISCOVER_SERVER') {
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
