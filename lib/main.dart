import 'package:flutter/material.dart';

import 'app.dart';
import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Composition root: build shared services once and wire them together.
  final tokenStorage = SharedPrefsTokenStorage();
  final apiClient = ApiClient(tokenStorage: tokenStorage);
  final auth = AuthProvider(
    AuthRepositoryImpl(
      remote: AuthRemoteDataSource(apiClient),
      storage: tokenStorage,
    ),
  );
  apiClient.onUnauthorized = auth.handleUnauthorized;

  // Restore a saved login before the first frame (no login flash).
  await auth.restore();

  runApp(TerraPeerApp(apiClient: apiClient, auth: auth));
}
