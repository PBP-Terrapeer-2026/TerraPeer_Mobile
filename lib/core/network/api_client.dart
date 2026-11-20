import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/env.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';

/// Single HTTP client for every module's Django REST Framework endpoint.
///
/// * Adds `Authorization: Token <token>` to authenticated requests.
/// * Encodes and decodes JSON (UTF-8).
/// * Turns every failure into an [ApiException].
/// * Calls [onUnauthorized] on HTTP 401 so the app can log the user out.
///
/// Usage inside a module's data source:
///   final json = await apiClient.get('/my-plants/');
class ApiClient {
  final http.Client _http;
  final TokenStorage _tokenStorage;
  final Duration timeout;

  /// Set by the auth layer; called when the server rejects the token.
  void Function()? onUnauthorized;

  ApiClient({
    required this._tokenStorage,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 20),
  }) : _http = httpClient ?? http.Client();

  Future<dynamic> get(String path, {Map<String, String>? query}) =>
      _send('GET', path, query: query);

  Future<dynamic> post(String path, {Object? body, bool authenticated = true}) =>
      _send('POST', path, body: body, authenticated: authenticated);

  Future<dynamic> put(String path, {Object? body}) => _send('PUT', path, body: body);

  Future<dynamic> patch(String path, {Object? body}) => _send('PATCH', path, body: body);

  Future<dynamic> delete(String path) => _send('DELETE', path);

  Future<dynamic> _send(
    String method,
    String path, {
    Object? body,
    Map<String, String>? query,
    bool authenticated = true,
  }) async {
    var uri = Env.api(path);
    if (query != null && query.isNotEmpty) {
      uri = uri.replace(queryParameters: {...uri.queryParameters, ...query});
    }

    final request = http.Request(method, uri)
      ..headers['Accept'] = 'application/json';
    if (body != null) {
      request.headers['Content-Type'] = 'application/json; charset=utf-8';
      request.body = jsonEncode(body);
    }
    if (authenticated) {
      final token = await _tokenStorage.readToken();
      if (token != null) request.headers['Authorization'] = 'Token $token';
    }

    final http.Response response;
    try {
      final streamed = await _http.send(request).timeout(timeout);
      response = await http.Response.fromStream(streamed);
    } on TimeoutException {
      throw const ApiException.network();
    } on http.ClientException {
      throw const ApiException.network();
    }

    final text = utf8.decode(response.bodyBytes);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return text.isEmpty ? null : jsonDecode(text);
    }

    final error = ApiException.fromResponse(response.statusCode, text);
    if (authenticated && error.isUnauthorized) onUnauthorized?.call();
    throw error;
  }

  void close() => _http.close();
}
