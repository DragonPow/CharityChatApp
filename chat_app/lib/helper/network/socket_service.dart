
import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  final IO.Socket socket;
  SocketService({required this.socket}) {
    socket.onConnect((data) {
      log('Socket connect success');
    });
    socket.on('messageSent', (data) {
      //TODO: Update to UI when receive message
    });
  }
}