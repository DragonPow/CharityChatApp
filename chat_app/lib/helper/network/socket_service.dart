
import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../constant.dart';

class SocketService {
  final socket = IO.io(socketUrl, IO.OptionBuilder().setTransports(['websocket']).build());

  SocketService() {
    // socket.connect();
    print('Socket is created');
    socket.onConnect((data) {
      print('Connect socket');
    });
    socket.onDisconnect((data) {
      print('Disconnect socket');
    });
  }

  connect() {
    socket.connect();
  }
  disconnect() {
    socket.disconnect();
  }

  emitLogin(String token) {
    socket.emit('login', token);
  }

  void addEventListener(String nameEvent, Function(dynamic) callback) {
    socket.on(nameEvent, callback);
  }
}