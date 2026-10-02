import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;

  AuthBloc({required this.remoteDataSource, required this.secureStorage})
    : super(AuthInitialState()) {
    on<LoginSubmittedEvent>((event, emit) async {
      emit(AuthLoadingState());

      try {
        final token = await remoteDataSource.login(event.email, event.password);

        await secureStorage.write(key: 'access_token', value: token);

        emit(AuthSuccessState(token: token));
      } catch (e) {
        emit(const AuthErrorState(message: 'E-mail ou senha inválidos.'));
      }
    });

    on<LogoutEvent>((event, emit) async {
      await secureStorage.delete(key: 'access_token');
      emit(AuthInitialState());
    });
  }
}
