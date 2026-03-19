// lib/app/theme/app_theme.dart
// Uygulamanın iki ana tema modu:
// 1) RageTheme: Karanlık, agresif, elektrik mavisi & kırmızı
// 2) ZenTheme: Koyu mor, sakinleştirici geçiş teması

import 'package:flutter/material.dart';

abstract class AppTheme {
  // ── Ortak Renkler ─────────────────────────────────────────────────────────
  static const Color electricBlue = Color(0xFF00BCD4);
  static const Color rageCrimson = Color(0xFFE53935);
  static const Color rageOrange = Color(0xFFFF7043);
  static const Color zenPurple = Color(0xFF7B1FA2);
  static const Color zenLavender = Color(0xFFCE93D8);
  static const Color darkSurface = Color(0xFF0A0A0F);
  static const Color darkCard = Color(0xFF13131F);
  static const Color darkCardElevated = Color(0xFF1E1E30);

  // ── RAGE THEME ─────────────────────────────────────────────────────────────
  static ThemeData get rage {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: electricBlue,
        secondary: rageCrimson,
        tertiary: rageOrange,
        surface: darkSurface,
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: darkSurface,
      cardColor: darkCard,
      fontFamily: 'RobotoMono',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.w900,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
        bodyMedium: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
        labelLarge: TextStyle(
          color: electricBlue,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: rageCrimson,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: electricBlue,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        iconTheme: IconThemeData(color: electricBlue),
      ),
    );
  }

  // ── ZEN THEME ──────────────────────────────────────────────────────────────
  static ThemeData get zen {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: zenLavender,
        secondary: zenPurple,
        surface: Color(0xFF0D0A1A),
        onPrimary: Colors.white,
        onSurface: Colors.white70,
      ),
      scaffoldBackgroundColor: const Color(0xFF080612),
      cardColor: const Color(0xFF110E20),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w300,
          letterSpacing: 3,
        ),
        bodyLarge: TextStyle(color: Color(0xFFD1C4E9), fontSize: 16),
        bodyMedium: TextStyle(color: Color(0xFFB39DDB), fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: zenPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF080612),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: zenLavender,
          fontSize: 18,
          fontWeight: FontWeight.w300,
          letterSpacing: 4,
        ),
      ),
    );
  }
}
