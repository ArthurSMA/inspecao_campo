import 'package:auto_route/auto_route.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';

import 'app_router.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard(this.authBloc);

  final AuthBloc authBloc;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (authBloc.state is AuthSuccessState) {
      resolver.next(true);
      return;
    }

    resolver.redirectUntil(
      LoginRoute(
        onResult: (success) {
          resolver.next(success);
        },
      ),
    );
  }
}
