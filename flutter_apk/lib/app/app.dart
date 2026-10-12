import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

export 'package:flutter/material.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/work_orders/data/database/work_orders_database.dart';
import '../features/work_orders/domain/repositories/inspection_repository.dart';
import '../features/work_orders/domain/repositories/work_orders_repository.dart';
import '../features/work_orders/presentation/bloc/inspection_bloc.dart';
import '../features/work_orders/presentation/bloc/work_orders_bloc.dart';
import 'app_dependencies.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  late final Future<AppDependencies> _dependencies;

  @override
  void initState() {
    super.initState();
    _dependencies = _initializeDependencies();
  }

  Future<AppDependencies> _initializeDependencies() async {
    if (!dotenv.isInitialized) {
      await dotenv.load(fileName: '.env');
    }
    return AppDependenciesFactory.create();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppDependencies>(
      future: _dependencies,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'Falha ao inicializar o aplicativo: ${snapshot.error}',
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final dependencies = snapshot.requireData;
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AppDatabase>(
              create: (_) => dependencies.database,
              dispose: (database) => unawaited(database.close()),
            ),
            RepositoryProvider<InspectionRepository>(
              create: (_) => dependencies.inspectionRepository,
            ),
            RepositoryProvider<WorkOrdersRepository>(
              create: (_) => dependencies.workOrdersRepository,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(create: (_) => dependencies.authBloc),
              BlocProvider<InspectionBloc>(
                create: (_) => dependencies.inspectionBloc,
              ),
              BlocProvider<WorkOrdersBloc>(
                create: (_) => dependencies.workOrdersBloc,
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
                      builder: (_) => isAuthenticated
                          ? const HomePage()
                          : const LoginPage(),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
