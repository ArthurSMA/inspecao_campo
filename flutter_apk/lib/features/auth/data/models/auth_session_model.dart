import '../../domain/entities/user.dart';
import 'user_model.dart';

class AuthSessionModel {
  const AuthSessionModel({required this.accessToken, required this.user});

  final String accessToken;
  final User user;

  factory AuthSessionModel.fromLoginJson(Map<String, dynamic> json) {
    final accessToken = json['accessToken'];
    final userJson = json['user'];

    if (accessToken is! String || accessToken.isEmpty) {
      throw const FormatException('Resposta de login sem accessToken válido.');
    }
    if (userJson is! Map<String, dynamic>) {
      throw const FormatException('Resposta de login sem perfil de usuário.');
    }

    return AuthSessionModel(
      accessToken: accessToken,
      user: UserModel.fromJson(userJson),
    );
  }
}
