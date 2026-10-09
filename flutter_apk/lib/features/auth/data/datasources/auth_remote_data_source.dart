import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inspecao_campo/core/network/dio_client.dart';

import '../../domain/errors/auth_unauthorized_exception.dart';
import '../models/auth_session_model.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthSessionModel> login(String email, String password);

  Future<UserModel> getCurrentUser();

  Future<String?> readAccessToken();

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _dioClient;
  final FlutterSecureStorage _secureStorage;

  AuthRemoteDataSourceImpl(
    this._dioClient, {
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<AuthSessionModel> login(String email, String password) async {
    try {
      final response = await _dioClient.instance.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final session = AuthSessionModel.fromLoginJson(
        Map<String, dynamic>.from(response.data as Map),
      );

      await _secureStorage.write(
        key: 'access_token',
        value: session.accessToken,
      );

      return session;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await logout();
        throw const AuthUnauthorizedException();
      }
      rethrow;
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dioClient.instance.get('/auth/me');
      return UserModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        await logout();
        throw const AuthUnauthorizedException();
      }
      rethrow;
    }
  }

  @override
  Future<String?> readAccessToken() {
    return _secureStorage.read(key: 'access_token');
  }

  @override
  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
  }
}
