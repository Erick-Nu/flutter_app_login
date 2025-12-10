import 'package:flutter/material.dart';

class AppTheme {
  // Colores personalizados
  static const Color primaryColor = Color(0xFF3BC8E7);
  static const Color backgroundDark = Color(0xFF0B1021);
  static const Color backgroundLight = Color(0xFF13254B);
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      // Definimos el esquema de colores global
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark, // Cambiamos a Dark porque tu UI es oscura
        primary: primaryColor,
        surface: backgroundLight,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundDark,
      // Estilo global de inputs para no repetirlo en cada widget
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor),
        ),
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIconColor: Colors.white70,
      ),
    );
  }
}