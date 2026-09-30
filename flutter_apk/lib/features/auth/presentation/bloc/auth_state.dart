import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final String token;
  const AuthSuccessState({required this.token});

  @override
  List<Object?> get props => [token];
}

class AuthErrorState extends AuthState {
  final String message;
  const AuthErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
