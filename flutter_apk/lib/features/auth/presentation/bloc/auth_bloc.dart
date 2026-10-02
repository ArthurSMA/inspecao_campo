import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/errors/auth_unauthorized_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitialState()) {
    on<CheckAuthSessionEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final session = await repository.restoreSession();
        if (session == null) {
          emit(AuthUnauthenticatedState());
          return;
        }
        emit(AuthSuccessState(token: session.accessToken, user: session.user));
      } on AuthUnauthorizedException {
        await repository.logout();
        emit(AuthUnauthenticatedState());
      } catch (_) {
        emit(const AuthErrorState(message: 'Falha ao validar a sessão.'));
      }
    });

    on<LoginSubmittedEvent>((event, emit) async {
      emit(AuthLoadingState());

      try {
        final session = await repository.login(event.email, event.password);
        emit(AuthSuccessState(token: session.accessToken, user: session.user));
      } on AuthUnauthorizedException {
        emit(const AuthErrorState(message: 'E-mail ou senha inválidos.'));
      } catch (_) {
        emit(
          const AuthErrorState(message: 'Falha ao conectar com o servidor.'),
        );
      }
    });

    on<LogoutEvent>((event, emit) async {
      await repository.logout();
      emit(AuthUnauthenticatedState());
    });
  }
}
