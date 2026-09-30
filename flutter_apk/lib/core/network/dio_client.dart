import 'package:dio/dio.dart';

import 'api_config.dart';
import 'auth_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient({Dio? dio}) {
    _dio = dio ?? Dio();

    _dio.options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio.interceptors.addAll([
      AuthInterceptor(),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  Dio get instance => _dio;
}
