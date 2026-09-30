import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;
  String? _token;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:3000',
        connectTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        }
      )
    );
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password
      });

      _token = response.data['token'];
      print(response.data);
      return true;
    } catch (e) {
      return false;
    }
  }
}
// void callAPI() async{
//   final dio = Dio();
//   final String token = "45bda350be1a26cafa4635519897ffac05adfd3adb24d32d";

// /*
//   final loginAuth = await dio.post(
//     "http://10.2.2:3000/auth/login",
//     // Pegar o token
//     // Retornar os dados do usuário
//     data: {'email', 'password'},
//   );
// */

//   // Usuário logado
//   final userAuth = await dio.get(
//     "http://10.0.2.2:3000/auth/me",
//     options: Options(
//       headers: {
//         'Authorization': 'Bearer $token'
//       },
//     ),
//   );

//   // Ordens de serviço
//   final workOrders = await dio.get(
//     "http://10.0.2.2:3000/work-orders",
//     options: Options(
//       headers: {
//         'Authorization': 'Bearer $token'
//       },
//     ),
//   );
//   // print('Status: ${userAuth.statusCode}');
//   print('User: ${userAuth.data}');
//   // print('Data ${workOrders.data}');

//   // final login = await dio.post("/auth/login",);
//   // final result = await dio.get();
// }
