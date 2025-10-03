import 'package:flutter/material.dart';

class AppTheme {
  static final Color primary = Color(0xFF6C63FF);
  static final Color bg = Color(0xFF0F1724);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: bg,
      fontFamily: 'Segoe UI',
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
