import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  /// ---- COLOR PALETTE ----
  static const primaryColor = Color(0xFFFC8019); // orange accent like Swiggy
  static const secondaryColor = Color(0xFF0E1630); // deep navy blue
  static const backgroundLight = Color(0xFFF8F9FC);
  static const backgroundDark = Color(0xFF0E0F12);

  /// ---- LIGHT THEME ----
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundLight,
    cardColor: Colors.white,
    useMaterial3: true,

    textTheme: GoogleFonts.poppinsTextTheme(),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
    ),

    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Colors.white,
      surfaceVariant: Color(0xFFEFF0F5),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        elevation: 3,
      ),
    ),
  );

  /// ---- DARK THEME ----
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundDark,
    cardColor: const Color(0xFF1A1C20),
    useMaterial3: true,

    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: backgroundDark,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),

    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Color(0xFF1A1C20),
      surfaceVariant: Color(0xFF24262B),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        elevation: 3,
      ),
    ),
  );
}
