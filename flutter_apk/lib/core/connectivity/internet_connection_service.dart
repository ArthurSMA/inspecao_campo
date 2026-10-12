abstract interface class InternetConnectionService {
  Stream<bool> get status;

  Future<bool> get hasInternetAccess;
}
