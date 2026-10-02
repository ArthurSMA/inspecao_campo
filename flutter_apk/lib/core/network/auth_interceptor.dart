import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  final Future<void> Function()? onUnauthorized;

  AuthInterceptor({FlutterSecureStorage? secureStorage, this.onUnauthorized})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(key: 'access_token');

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _secureStorage.delete(key: 'access_token');

      if (onUnauthorized != null) {
        await onUnauthorized!();
      }
    }
    return handler.next(err);
  }
}
