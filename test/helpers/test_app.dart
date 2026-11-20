import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terrapeer_mobile/app.dart';
import 'package:terrapeer_mobile/core/network/api_client.dart';
import 'package:terrapeer_mobile/core/network/api_exception.dart';
import 'package:terrapeer_mobile/core/storage/token_storage.dart';
import 'package:terrapeer_mobile/features/auth/domain/entities/session.dart';
import 'package:terrapeer_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:terrapeer_mobile/features/auth/presentation/providers/auth_provider.dart';

const phoneSize = Size(400, 900);
const tabletSize = Size(1200, 900);

/// In-memory auth backend: accepts only farel / rahasia123.
class FakeAuthRepository implements AuthRepository {
  static const validUsername = 'farel';
  static const validPassword = 'rahasia123';

  Session? stored;
  int loginCalls = 0;

  FakeAuthRepository({this.stored});

  @override
  Future<Session> login({required String username, required String password}) async {
    loginCalls++;
    if (username != validUsername || password != validPassword) {
      throw const ApiException(
        statusCode: 400,
        message: 'Unable to log in with provided credentials.',
      );
    }
    return stored = Session(username: username, token: 'test-token');
  }

  @override
  Future<Session?> restoreSession() async => stored;

  @override
  Future<void> logout() async => stored = null;
}

/// Pumps the full app (real router, shell and pages) with fake services.
Future<AuthProvider> pumpTerraPeer(
  WidgetTester tester, {
  bool loggedIn = true,
  Size size = phoneSize,
  FakeAuthRepository? repository,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final repo = repository ??
      FakeAuthRepository(
        stored: loggedIn
            ? const Session(username: FakeAuthRepository.validUsername, token: 'test-token')
            : null,
      );
  final auth = AuthProvider(repo);
  await auth.restore();

  await tester.pumpWidget(TerraPeerApp(
    apiClient: ApiClient(tokenStorage: InMemoryTokenStorage()),
    auth: auth,
    useGoogleFonts: false,
  ));
  await tester.pumpAndSettle();
  return auth;
}
