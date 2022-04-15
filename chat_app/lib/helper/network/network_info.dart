import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInforImp implements NetworkInfo {
  final Connectivity connectionChecker;

  NetworkInforImp({required this.connectionChecker});

  @override
  Future<bool> get isConnected => connectionChecker
      .checkConnectivity()
      .then((result) => result != ConnectivityResult.none);
}
