import 'package:flutter/material.dart';

/// App theme configuration for Photo Gallery App - Modern Minimalist Design
class AppThemes {
  // Teal & Coral color scheme - modern and vibrant
  static const Color _primaryColor = Color(0xFF00897B); // Teal 600
  static const Color _secondaryColor = Color(0xFFFF6F61); // Coral
  static const Color _accentColor = Color(0xFF26A69A); // Teal 400
  static const Color _backgroundColor = Color(0xFFF8F9FA); // Light gray
  static const Color _surfaceColor = Color(0xFFFFFFFF); // Pure white
  static const Color _onSurface = Color(0xFF1A1A1A); // Dark gray

  /// Light theme - Modern Minimalist
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: _primaryColor,
    scaffoldBackgroundColor: _backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
      secondary: _secondaryColor,
      tertiary: _accentColor,
      surface: _surfaceColor,
      onSurface: _onSurface,
      background: _backgroundColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _surfaceColor,
      foregroundColor: _onSurface,
      elevation: 0, // Flat design - no shadow
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: _onSurface,
        letterSpacing: 0.5,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _secondaryColor,
      foregroundColor: Colors.white,
      elevation: 0, // No shadow
      shape: CircleBorder(),
    ),
    cardTheme: const CardThemeData(
      elevation: 0, // Flat design
      color: _surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: _onSurface,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: _onSurface,
        letterSpacing: -0.25,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _onSurface,
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF424242),
        letterSpacing: 0.25,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF757575),
        letterSpacing: 0.25,
      ),
    ),
    iconTheme: const IconThemeData(color: _primaryColor),
  );

  /// Dark theme - Modern Dark Mode
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: _accentColor,
    scaffoldBackgroundColor: const Color(0xFF0F0F0F), // Very dark background
    colorScheme: const ColorScheme.dark(
      primary: _accentColor,
      secondary: _secondaryColor,
      tertiary: _primaryColor,
      surface: Color(0xFF1A1A1A), // Dark surface
      onSurface: Color(0xFFE5E5E5), // Light text
      background: Color(0xFF0F0F0F),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      foregroundColor: Color(0xFFE5E5E5),
      elevation: 0, // Flat design
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE5E5E5),
        letterSpacing: 0.5,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _secondaryColor,
      foregroundColor: Colors.white,
      elevation: 0, // No shadow
      shape: CircleBorder(),
    ),
    cardTheme: const CardThemeData(
      elevation: 0, // Flat design
      color: Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: Color(0xFF333333), width: 1),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Color(0xFFE5E5E5),
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE5E5E5),
        letterSpacing: -0.25,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE5E5E5),
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFFBDBDBD),
        letterSpacing: 0.25,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF9E9E9E),
        letterSpacing: 0.25,
      ),
    ),
    iconTheme: const IconThemeData(color: _accentColor),
  );
}
