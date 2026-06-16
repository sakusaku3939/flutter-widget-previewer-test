import 'package:flutter/material.dart';

import '../../core/design/app_tokens.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppTokens.primary,
      brightness: Brightness.light,
      primary: AppTokens.primary,
      surface: AppTokens.surface,
      error: AppTokens.error,
    );

    return _base(colorScheme).copyWith(
      scaffoldBackgroundColor: AppTokens.background,
      cardColor: AppTokens.surface,
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppTokens.primary,
      brightness: Brightness.dark,
      primary: Colors.white,
      surface: const Color(0xFF151922),
      error: const Color(0xFFFCA5A5),
    );

    return _base(colorScheme).copyWith(
      scaffoldBackgroundColor: const Color(0xFF0B0F17),
      cardColor: const Color(0xFF151922),
    );
  }

  static ThemeData _base(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'NotoSansJP',
      colorScheme: colorScheme,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: AppTokens.headingWeight,
          height: 1.2,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: AppTokens.headingWeight,
          height: 1.35,
        ),
        bodyMedium: TextStyle(fontSize: 16, height: 1.55),
        bodySmall: TextStyle(fontSize: 14, height: 1.45),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.cardRadius),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.buttonRadius),
          ),
        ),
      ),
      appBarTheme: AppBarThemeData(
        elevation: 0,
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
    );
  }
}
