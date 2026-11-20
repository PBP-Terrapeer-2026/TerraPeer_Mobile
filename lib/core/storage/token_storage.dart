import 'package:shared_preferences/shared_preferences.dart';

/// Persists the DRF auth token between app launches.
abstract class TokenStorage {
  Future<String?> readToken();
  Future<String?> readUsername();
  Future<void> save({required String token, required String username});
  Future<void> clear();
}

class SharedPrefsTokenStorage implements TokenStorage {
  static const _tokenKey = 'auth_token';
  static const _usernameKey = 'auth_username';

  String? _cachedToken;

  @override
  Future<String?> readToken() async {
    if (_cachedToken != null) return _cachedToken;
    final prefs = await SharedPreferences.getInstance();
    return _cachedToken = prefs.getString(_tokenKey);
  }

  @override
  Future<String?> readUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  @override
  Future<void> save({required String token, required String username}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_usernameKey, username);
    _cachedToken = token;
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
    _cachedToken = null;
  }
}

/// Non-persistent storage for widget tests.
class InMemoryTokenStorage implements TokenStorage {
  String? _token;
  String? _username;

  InMemoryTokenStorage({this._token, this._username});

  @override
  Future<String?> readToken() async => _token;

  @override
  Future<String?> readUsername() async => _username;

  @override
  Future<void> save({required String token, required String username}) async {
    _token = token;
    _username = username;
  }

  @override
  Future<void> clear() async {
    _token = null;
    _username = null;
  }
}
