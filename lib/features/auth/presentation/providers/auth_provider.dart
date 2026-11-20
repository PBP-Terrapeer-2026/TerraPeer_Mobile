import 'package:flutter/foundation.dart';

import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus { unknown, authenticated, guest }

/// App-wide login state. The router listens to it: logging in or out
/// automatically moves the user to the right page.
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthStatus _status = AuthStatus.unknown;
  Session? _session;

  AuthProvider(this._repository);

  AuthStatus get status => _status;
  Session? get session => _session;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  String? get username => _session?.username;

  /// Called once at startup, before the first frame.
  Future<void> restore() async {
    _session = await _repository.restoreSession();
    _status = _session == null ? AuthStatus.guest : AuthStatus.authenticated;
    notifyListeners();
  }

  /// Throws ApiException when the credentials are rejected; the login page
  /// shows the message.
  Future<void> login({required String username, required String password}) async {
    _session = await _repository.login(username: username.trim(), password: password);
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> logout() async {
    await _repository.logout();
    _setGuest();
  }

  /// Called by ApiClient when the server answers 401 (expired/revoked token).
  void handleUnauthorized() {
    if (!isAuthenticated) return;
    _repository.logout();
    _setGuest();
  }

  void _setGuest() {
    _session = null;
    _status = AuthStatus.guest;
    notifyListeners();
  }
}
