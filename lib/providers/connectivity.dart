import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';

class ConnectionStatusSingleton with ChangeNotifier {
  ConnectionStatusSingleton._internal();
  static final ConnectionStatusSingleton _singleton =
      ConnectionStatusSingleton._internal();

  static ConnectionStatusSingleton getInstance() => _singleton;

  bool hasConnection = false;

  StreamController connectionChangeController = StreamController.broadcast();
  final Connectivity _connectivity = Connectivity();

  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  @override
  void dispose() {
    connectionChangeController.close();
    super.dispose();
  }

  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  Future<bool> checkConnection() async {
    final previousConnection = hasConnection;

    if (kIsWeb) {
      final _isConnected = window.navigator.onLine;
      if (_isConnected == true) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } else {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          hasConnection = true;
        } else {
          hasConnection = false;
        }
      } on SocketException catch (_) {
        hasConnection = false;
      }
    }

    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }
    notifyListeners();
    return hasConnection;
  }
}
