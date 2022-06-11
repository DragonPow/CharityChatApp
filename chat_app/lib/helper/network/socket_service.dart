import 'dart:async';
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

class StreamSocket {
  final _socketRes = StreamController();
  void Function(dynamic) get addResponse => _socketRes.sink.add;
  void dispose() {
    _socketRes.close();
  }
}

class SocketService {
  final _socket = IO.io(socketUrl, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
    'connect_timeout': 210,
  });
  // final _streamSocket = StreamSocket();
  // StreamSocket get stream => _streamSocket;

  dispose() {
    // _streamSocket.dispose();
  }

  SocketService() {
    // socket.connect();
    print('Socket is created');
    _socket.onConnect((data) {
      print('Socket connected');
    });
    _socket.onReconnect((data) {
      print('Socket is reconnect');
    });
    _socket.onDisconnect((data) {
      print('Socket disconnected');
    });
    _socket.onConnectError((data) {
      print('Connect error');
      print(data);
    });
    _socket.onError((data) {
      print('Socket is error');
      print(data);
    });
    _socket.on('messageSent', (data) {
      log('Receive message');
      print(data.toString());
    });
  }

  void connect() {
    _socket.connect();
  }

  void disconnect() {
    _socket.disconnect();
  }

  void close() {
    _socket.close();
  }

  void emitLogin(String token) {
    _socket.emit('login', token);
  }

  void emit(String nameEvent, [dynamic data]) {
    _socket.emit(nameEvent, data);
  }

  void addEventListener(String nameEvent, dynamic Function(dynamic) callback) {
    print('Socket event listener ' + nameEvent + ' is added');
    _socket.on(nameEvent, callback);
  }

  void addEventReconnect(dynamic Function(dynamic) callback) =>
      _socket.onReconnect(callback);
  void removeEventListener(String nameEvent,
      [dynamic Function(dynamic)? handler]) {
    print('Socket event listener ' + nameEvent + ' is remove');
    _socket.off(nameEvent, handler);
  }
}
