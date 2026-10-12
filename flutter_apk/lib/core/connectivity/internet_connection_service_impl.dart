import 'package:internet_connection_checker_plus/'
    'internet_connection_checker_plus.dart';

import 'internet_connection_service.dart';

class InternetConnectionServiceImpl implements InternetConnectionService {
  InternetConnectionServiceImpl() : _connection = InternetConnection();

  final InternetConnection _connection;

  @override
  Stream<bool> get status => _connection.onStatusChange
      .map((status) => status == InternetStatus.connected)
      .distinct();

  @override
  Future<bool> get hasInternetAccess {
    return _connection.hasInternetAccess;
  }
}
