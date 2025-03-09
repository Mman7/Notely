import 'dart:convert';
import 'dart:io';

class SocketService {
  // transfer via udp or tcp, udp can transfer data without ip address
  startSocket() async {
    // Bind the server to any local address and a port
    final server = await RawDatagramSocket.bind('127.0.0.1', 8080);
    print('Server started, waiting for broadcast...');

    server.listen((event) {
      if (event == RawSocketEvent.read) {
        Datagram? dg = server.receive();
        if (dg != null) {
          String receivedMessage = utf8.decode(dg.data);
          print('Received broadcast from ${dg.address.address}:${dg.port}');

          if (receivedMessage == 'DISCOVER_SERVER') {
            // Respond with the server IP address
            String response = 'SERVER_IP: ${server.address.address}';
            server.send(utf8.encode(response), dg.address, dg.port);
          }
        }
      }
    });
  }

  sendMsg() async {
    final client = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

    // Send broadcast message to the network
    client.send(utf8.encode('DISCOVER_SERVER'),
        InternetAddress('255.255.255.255'), 8080);
    print('Sent discovery message to the network.');

    // Listen for the response from the server
    client.listen((event) async {
      if (event == RawSocketEvent.read) {
        Datagram? dg = client.receive();
        if (dg != null) {
          String serverResponse = utf8.decode(dg.data);
          print('Server Response: $serverResponse');

          // Extract the server's IP from the response
          String serverIp = serverResponse.split(': ')[1];

          // Attempt to connect to the server at the discovered IP
          await connectToServer(serverIp);
        }
      }
    });
  }

  Future<void> connectToServer(String ip) async {
    final socket = await Socket.connect(ip, 8080);
    print('Connected to server at $ip');
    socket.write(utf8.encode('Hello Server!'));
    await socket.close();
  }
}
