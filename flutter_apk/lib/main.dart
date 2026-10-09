import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/network/dio_client.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/work_orders/data/database/work_orders_database.dart';
import 'features/work_orders/data/datasources/inspection_remote_data_source.dart';
import 'features/work_orders/data/repositories/inspection_repository_impl.dart';
import 'features/work_orders/presentation/bloc/inspection_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            repository: AuthRepositoryImpl(
              AuthRemoteDataSourceImpl(
                ApiClient(),
                secureStorage: const FlutterSecureStorage(),
              ),
            ),
          )..add(CheckAuthSessionEvent()),
        ),
        BlocProvider<InspectionBloc>(
          create: (context) => InspectionBloc(
            InspectionRepositoryImpl(
              remoteDataSource: InspectionRemoteDataSourceImpl(
                ApiClient().instance,
              ),
              database: AppDatabase(),
            ),
          ),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticatedState) {
            _navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/login',
              (_) => false,
            );
          }
        },
        child: Builder(
          builder: (context) => MaterialApp(
            navigatorKey: _navigatorKey,
            title: 'Inspeção de Campo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true),
            initialRoute: '/login',
            routes: {'/login': (_) => const LoginPage()},
            onGenerateRoute: (settings) {
              if (settings.name != '/home') {
                return null;
              }

              final isAuthenticated =
                  context.read<AuthBloc>().state is AuthSuccessState;
              return MaterialPageRoute<void>(
                settings: RouteSettings(
                  name: isAuthenticated ? '/home' : '/login',
                ),
                builder: (_) =>
                    isAuthenticated ? const HomePage() : const LoginPage(),
              );
            },
          ),
        ),
      ),
    );
  }
}
