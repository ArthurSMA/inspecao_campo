import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inspecao_campo/features/home/presentation/pages/home_page.dart';
import 'package:inspecao_campo/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders the login page after checking an empty session', (
    tester,
  ) async {
    dotenv.loadFromString(envString: 'BASE_URL=http://localhost:3000');

    const secureStorageChannel = MethodChannel(
      'plugins.it_nomads.com/flutter_secure_storage',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, (call) async => null);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo de volta!'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, null);
  });

  testWidgets('redirects unauthenticated access to /home to login', (
    tester,
  ) async {
    dotenv.loadFromString(envString: 'BASE_URL=http://localhost:3000');

    const secureStorageChannel = MethodChannel(
      'plugins.it_nomads.com/flutter_secure_storage',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, (call) async => null);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    Navigator.of(tester.element(find.text('Entrar'))).pushNamed('/home');
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo de volta!'), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, null);
  });
}
