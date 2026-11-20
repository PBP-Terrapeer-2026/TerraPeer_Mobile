import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';

/// Talks to the Django token endpoint: POST /api/v1/auth/token/
/// (rest_framework.authtoken obtain_auth_token).
class AuthRemoteDataSource {
  final ApiClient _api;

  const AuthRemoteDataSource(this._api);

  Future<String> obtainToken({required String username, required String password}) async {
    final json = await _api.post(
      '/auth/token/',
      body: {'username': username, 'password': password},
      authenticated: false,
    );
    final token = json is Map<String, dynamic> ? json['token'] : null;
    if (token is! String || token.isEmpty) {
      throw const ApiException(message: 'Respons login dari server tidak valid.');
    }
    return token;
  }
}
