import 'dart:developer';
import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../constant.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class SocketService {
  final socket = IO.io(socketUrl, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  SocketService() {
    // socket.connect();
    print('Socket is created');
    socket.onConnect((data) {
      print('Socket connected');
    });
    socket.onDisconnect((data) {
      print('Socket disconnected');
    });
    socket.onConnectError((data) {
      print('Connect error');
      print(data);
    });
    socket.onError((data) {
      print('Is error');
      print(data);
    });
  }

  connect() {
    socket.connect();
  }

  disconnect() {
    socket.disconnect();
  }

  void emitLogin(String token) {
    socket.emit('login', token);
  }

  void emit(String nameEvent, [dynamic data]) {
    socket.emit(nameEvent, data);
  }

  void addEventListener(String nameEvent, dynamic Function(dynamic) callback) {
    socket.on(nameEvent, callback);
  }

  void addEventReconnect(dynamic Function(dynamic) callback) =>
      socket.onReconnect(callback);
  void removeEventListener(String nameEvent) {
    socket.off(nameEvent);
  }
}
