import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/network/dio_client.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            remoteDataSource: AuthRemoteDataSource(dioClient: DioClient()),
            secureStorage: const FlutterSecureStorage(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Inspeção de Campo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const LoginPage(),
      ),
    );
  }
}
