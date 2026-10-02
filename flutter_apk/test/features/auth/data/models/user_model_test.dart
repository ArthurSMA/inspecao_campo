import 'package:flutter_test/flutter_test.dart';
import 'package:inpecao_campo/features/auth/data/models/auth_session_model.dart';
import 'package:inpecao_campo/features/auth/data/models/user_model.dart';

void main() {
  const userJson = {
    'id': 'u_001',
    'name': 'Ana Técnica',
    'email': 'tecnico@orbytis.com.br',
    'role': 'field_technician',
  };

  test('maps the direct /auth/me user payload', () {
    final user = UserModel.fromJson(userJson);

    expect(user.id, 'u_001');
    expect(user.name, 'Ana Técnica');
    expect(user.email, 'tecnico@orbytis.com.br');
    expect(user.role, 'field_technician');
  });

  test('maps the user nested in the login response', () {
    final session = AuthSessionModel.fromLoginJson({
      'accessToken': 'access-token',
      'tokenType': 'Bearer',
      'expiresIn': 86400,
      'user': userJson,
    });

    expect(session.accessToken, 'access-token');
    expect(session.user, UserModel.fromJson(userJson));
  });
}
