import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

/// Root widget. Shared services are created in `main.dart` (or by tests)
/// and handed down with Provider, so every module reads them with
/// `context.read<ApiClient>()` / `context.watch<AuthProvider>()`.
class TerraPeerApp extends StatefulWidget {
  final ApiClient apiClient;
  final AuthProvider auth;

  /// Set to false in widget tests: Google Fonts would try to download fonts.
  final bool useGoogleFonts;

  const TerraPeerApp({
    super.key,
    required this.apiClient,
    required this.auth,
    this.useGoogleFonts = true,
  });

  @override
  State<TerraPeerApp> createState() => _TerraPeerAppState();
}

class _TerraPeerAppState extends State<TerraPeerApp> {
  late final GoRouter _router = createAppRouter(widget.auth);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: widget.apiClient),
        ChangeNotifierProvider<AuthProvider>.value(value: widget.auth),
      ],
      child: MaterialApp.router(
        title: 'TerraPeer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(useGoogleFonts: widget.useGoogleFonts),
        routerConfig: _router,
      ),
    );
  }
}
