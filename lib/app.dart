import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class TerraPeerApp extends StatefulWidget {
  /// Set to false in widget tests: Google Fonts would try to download fonts.
  final bool useGoogleFonts;

  const TerraPeerApp({super.key, this.useGoogleFonts = true});

  @override
  State<TerraPeerApp> createState() => _TerraPeerAppState();
}

class _TerraPeerAppState extends State<TerraPeerApp> {
  late final GoRouter _router = createAppRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TerraPeer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(useGoogleFonts: widget.useGoogleFonts),
      routerConfig: _router,
    );
  }
}
