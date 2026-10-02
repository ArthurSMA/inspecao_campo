import '../../domain/repositories/auth_repository.dart';
import '../../domain/errors/auth_unauthorized_exception.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this.remoteDataSource);

  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<AuthSession> login(String email, String password) async {
    final session = await remoteDataSource.login(email, password);
    final user = await remoteDataSource.getCurrentUser();
    return AuthSession(accessToken: session.accessToken, user: user);
  }

  @override
  Future<AuthSession?> restoreSession() async {
    final token = await remoteDataSource.readAccessToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    try {
      final user = await remoteDataSource.getCurrentUser();
      return AuthSession(accessToken: token, user: user);
    } on AuthUnauthorizedException {
      await remoteDataSource.logout();
      return null;
    }
  }

  @override
  Future<void> logout() => remoteDataSource.logout();
}
