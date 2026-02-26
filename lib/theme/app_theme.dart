import 'package:flutter/material.dart';
import '../models/index.dart';

class AppTheme {
  // Male Theme (Blue)
  static final ThemeData maleTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFF3B82F6),
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFAFAFA),
      foregroundColor: Color(0xFF000000),
      elevation: 0,
      centerTitle: true,
    ),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF3B82F6),
      secondary: const Color(0xFF60A5FA),
      surface: const Color(0xFFFFFFFF),
      error: const Color(0xFFEF4444),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: const Color(0xFF000000),
      onError: Colors.white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF000000),
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF000000),
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF000000),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF000000),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF666666),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  // Female Theme (Pink)
  static final ThemeData femaleTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFFEC4899),
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFAFAFA),
      foregroundColor: Color(0xFF000000),
      elevation: 0,
      centerTitle: true,
    ),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFFEC4899),
      secondary: const Color(0xFFF472B6),
      surface: const Color(0xFFFFFFFF),
      error: const Color(0xFFEF4444),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: const Color(0xFF000000),
      onError: Colors.white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF000000),
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF000000),
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF000000),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF000000),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF666666),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFEC4899), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEC4899),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  static ThemeData getTheme(UserTheme theme) {
    return theme == UserTheme.male ? maleTheme : femaleTheme;
  }

  static Color getPrimaryColor(UserTheme theme) {
    return theme == UserTheme.male
        ? const Color(0xFF3B82F6)
        : const Color(0xFFEC4899);
  }

  static Color getSecondaryColor(UserTheme theme) {
    return theme == UserTheme.male
        ? const Color(0xFF60A5FA)
        : const Color(0xFFF472B6);
  }
}
