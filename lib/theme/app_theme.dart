import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color midnightBlue = Color(0xFF0E1A2B);
  static const Color stoneGray = Color(0xFF9A9EAA);
  static const Color parchment = Color(0xFFF4E9D4);
  static const Color bronze = Color(0xFF9D6B3F);
  static const Color softGold = Color(0xFFD1B16A);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: bronze,
      brightness: Brightness.light,
      primary: bronze,
      secondary: softGold,
      surface: const Color(0xFFFFFAF1),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF8F2E7),
      textTheme: GoogleFonts.cormorantGaramondTextTheme(),
      appBarTheme: const AppBarTheme(centerTitle: false),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: softGold,
      onPrimary: Color(0xFF1A1A1A),
      secondary: bronze,
      onSecondary: Colors.white,
      error: Color(0xFFEF9A9A),
      onError: Colors.black,
      surface: Color(0xFF101827),
      onSurface: Color(0xFFF1EDE3),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: midnightBlue,
      textTheme: GoogleFonts.cormorantGaramondTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF152238),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFF2D3A4D), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: const Color(0xFF18253A),
      ),
    );
  }
}
