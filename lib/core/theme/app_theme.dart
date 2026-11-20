import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Single theme for the whole app. Use `Theme.of(context)` in every module
/// instead of hard-coding colors or text styles.
///
/// Typography follows the website: Plus Jakarta Sans for body text and
/// Lora for headings.
class AppTheme {
  AppTheme._();

  static ThemeData light({bool useGoogleFonts = true}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.moss,
      tertiary: AppColors.sun,
      error: AppColors.danger,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      outline: AppColors.lineStrong,
      outlineVariant: AppColors.line,
    );

    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final textTheme = useGoogleFonts ? _textTheme(base.textTheme) : base.textTheme;

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.paper,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(64, 48),
          side: const BorderSide(color: AppColors.lineStrong),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lineStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lineStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
      ),
      navigationDrawerTheme: const NavigationDrawerThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: Color(0xFFDDE8D3),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: Color(0xFFDDE8D3),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    // Apply fonts per TextStyle instead of GoogleFonts.*TextTheme():
    // google_fonts 9 builds its TextTheme helpers on the separate
    // material_ui package, whose TextTheme type differs from Flutter's.
    final bodyFamily = GoogleFonts.plusJakartaSans().fontFamily;
    final body = base.apply(fontFamily: bodyFamily);
    TextStyle? serif(TextStyle? s) =>
        s == null ? null : GoogleFonts.lora(textStyle: s, fontWeight: FontWeight.w600);
    return body.copyWith(
      displayLarge: serif(body.displayLarge),
      displayMedium: serif(body.displayMedium),
      displaySmall: serif(body.displaySmall),
      headlineLarge: serif(body.headlineLarge),
      headlineMedium: serif(body.headlineMedium),
      headlineSmall: serif(body.headlineSmall),
    );
  }
}
