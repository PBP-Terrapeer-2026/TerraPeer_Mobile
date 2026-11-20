import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final TokenStorage _storage;

  const AuthRepositoryImpl({required this._remote, required this._storage});

  @override
  Future<Session> login({required String username, required String password}) async {
    final token = await _remote.obtainToken(username: username, password: password);
    await _storage.save(token: token, username: username);
    return Session(username: username, token: token);
  }

  @override
  Future<Session?> restoreSession() async {
    final token = await _storage.readToken();
    final username = await _storage.readUsername();
    if (token == null || username == null) return null;
    return Session(username: username, token: token);
  }

  @override
  Future<void> logout() => _storage.clear();
}
