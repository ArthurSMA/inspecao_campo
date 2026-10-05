import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class NetworkConnectivityService {
  Stream<List<ConnectivityResult>> get changes;
  Future<bool> get isConnected;
}

class NetworkConnectivityServiceImpl implements NetworkConnectivityService {
  NetworkConnectivityServiceImpl({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Stream<List<ConnectivityResult>> get changes =>
      _connectivity.onConnectivityChanged;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}
