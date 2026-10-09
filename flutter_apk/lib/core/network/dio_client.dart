import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'auth_interceptor.dart';

class ApiClient {
  static String get baseUrl => dotenv.get("BASE_URL");
  late final Dio _dio;

  ApiClient({Dio? dio}) {
    _dio = dio ?? Dio();

    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio.interceptors.addAll([
      AuthInterceptor(),
      LogInterceptor(requestBody: false, responseBody: false),
    ]);
  }

  Dio get instance => _dio;
}
