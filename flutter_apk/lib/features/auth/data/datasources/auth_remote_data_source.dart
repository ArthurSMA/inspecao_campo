import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inpecao_campo/core/network/dio_client.dart';

class AuthRemoteDataSource {
  final DioClient _dioClient;
  final FlutterSecureStorage _secureStorage;

  AuthRemoteDataSource({
    required DioClient dioClient,
    FlutterSecureStorage? secureStorage,
  }) : _dioClient = dioClient,
       _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<String> login(String email, String password) async {
    try {
      final response = await _dioClient.instance.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final String accessToken = response.data['accessToken'];

      await _secureStorage.write(key: 'access_token', value: accessToken);

      return accessToken;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Credenciais inválidas');
      }
      throw Exception('Falha ao conectar com o servidor');
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
  }
}
