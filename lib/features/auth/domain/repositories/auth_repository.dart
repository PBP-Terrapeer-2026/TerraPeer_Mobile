import '../entities/session.dart';

/// Contract the presentation layer depends on. The data layer provides the
/// real implementation; tests provide a fake one.
abstract class AuthRepository {
  /// Throws ApiException when the credentials are rejected.
  Future<Session> login({required String username, required String password});

  /// Session saved from a previous launch, or null.
  Future<Session?> restoreSession();

  Future<void> logout();
}
