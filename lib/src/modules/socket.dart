import 'dart:io';

//telnet actually connnected to server and can send text?? or key i pressed

class SocketClient {
  String indexRequest = 'GET / HTTP/1.1\nConnection: close\n\n';
  conenct() {
    Socket.connect('localhost', 4567).then((socket) {
      print('cli Connected to: '
          '${socket.remoteAddress.address}:${socket.remotePort}');

      socket.writeln(indexRequest);
      socket.listen(
        (data) {
          print(new String.fromCharCodes(data).trim());
        },
      );
    });
  }
}

class SocketService {
  Socket? socket;
  main() {
    ServerSocket.bind(InternetAddress.anyIPv4, 4567)
        .then((ServerSocket server) {
      print(server.address.address);
      server.listen((client) {
        client.write('someone connect to server');
        client.write(client.address);

        client.listen((data) {
          print('got data this is server');
          print(new String.fromCharCodes(data).trim());
          print('got data this is server');
        });
      });
      // server.listen(handleClient,
      //     onError: errorHandler, onDone: doneHandler, cancelOnError: false);
    });
  }

  void dataHandler(data) {
    print(new String.fromCharCodes(data).trim());
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    socket?.destroy();
    exit(0);
  }

  void handleClient(Socket client) {
    client.write("Hello from simple server!\n");
    client.close();
  }
}
