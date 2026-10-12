import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_dependencies.dart';
import 'router/app_router.dart';
import 'router/auth_guard.dart';

export 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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

        final appRouter = AppRouter(
          authGuard: AuthGuard(dependencies.authBloc),
        );

        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: dependencies.database),
            RepositoryProvider.value(value: dependencies.inspectionRepository),
            RepositoryProvider.value(value: dependencies.workOrdersRepository),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: dependencies.authBloc),
              BlocProvider.value(value: dependencies.inspectionBloc),
              BlocProvider.value(value: dependencies.workOrdersBloc),
            ],
            child: MaterialApp.router(
              title: 'Inspeção de Campo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(useMaterial3: true),
              routerConfig: appRouter.config(
                reevaluateListenable: ReevaluateListenable.stream(
                  dependencies.authBloc.stream,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
