import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: Colors.black,
        secondary: Colors.black,
        surface: Colors.white,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onError: Colors.white,
      ),
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      // Card Theme
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // Text Theme
      textTheme: const TextTheme(
        // Display styles
        displayLarge: TextStyle(
          fontFamily: 'Balapan',
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        displayMedium: TextStyle(
          fontFamily: 'OPTIRadiant',
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        displaySmall: TextStyle(
          fontFamily: 'OPTIRadiant',
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        
        // Title styles
        titleLarge: TextStyle(
          fontFamily: 'OPTIRadiant',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        titleMedium: TextStyle(
          fontFamily: 'OPTIRadiant',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        titleSmall: TextStyle(
          fontFamily: 'OPTIRadiant',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        
        // Body styles
        bodyLarge: TextStyle(
          fontFamily: 'Nonesuch',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Nonesuch',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Nonesuch',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        
        // Label styles
        labelLarge: TextStyle(
          fontFamily: 'Nonesuch',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Nonesuch',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Nonesuch',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: Colors.white,
        secondary: Colors.white,
        surface: Colors.black,
        error: Colors.red,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onError: Colors.black,
      ),
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      // Card Theme
      cardTheme: CardTheme(
        color: Colors.grey[900],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // Text Theme
      textTheme: const TextTheme(
        // Display styles
        displayLarge: TextStyle(
          fontFamily: 'Balapan',
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontFamily: 'OPTIRadiant',
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontFamily: 'OPTIRadiant',
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        
        // Title styles
        titleLarge: TextStyle(
          fontFamily: 'OPTIRadiant',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontFamily: 'OPTIRadiant',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        titleSmall: TextStyle(
          fontFamily: 'OPTIRadiant',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        
        // Body styles
        bodyLarge: TextStyle(
          fontFamily: 'Nonesuch',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Nonesuch',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Nonesuch',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        
        // Label styles
        labelLarge: TextStyle(
          fontFamily: 'Nonesuch',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Nonesuch',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Nonesuch',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
