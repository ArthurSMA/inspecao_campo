import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inspecao_campo/core/network/dio_client.dart';
import 'package:inspecao_campo/features/auth/data/datasources/auth_remote_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('GET /auth/me sends the stored bearer token', () async {
    dotenv.loadFromString(envString: 'BASE_URL=http://localhost:3000');

    const secureStorageChannel = MethodChannel(
      'plugins.it_nomads.com/flutter_secure_storage',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, (call) async {
          if (call.method == 'read') {
            return 'stored-token';
          }
          return null;
        });

    final dio = Dio();
    final client = DioClient(dio: dio);
    RequestOptions? capturedRequest;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          capturedRequest = options;
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: {
                'id': 'u_001',
                'name': 'Ana Técnica',
                'email': 'tecnico@orbytis.com.br',
                'role': 'field_technician',
              },
            ),
          );
        },
      ),
    );

    final dataSource = AuthRemoteDataSourceImpl(
      client,
      secureStorage: const FlutterSecureStorage(),
    );

    final user = await dataSource.getCurrentUser();

    expect(user.id, 'u_001');
    expect(capturedRequest?.path, '/auth/me');
    expect(capturedRequest?.headers['Authorization'], 'Bearer stored-token');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, null);
  });
}
