import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF020B18);
  static const Color primary = Color(0xFF071B3B);
  static const Color secondary = Color(0xFF0D2D66);
  static const Color accent = Color(0xFFC79A3B);
  static const Color highlight = Color(0xFFE0BC74);
  static const Color cardColor = Color(0xFF0F1F3D);
  static const Color textPrimary = Color(0xFFF7F5F2);
  static const Color textSecondary = Color(0xFFB0ABA3);
  static const Color textMuted = Color(0xFF6B6560);
  static const Color divider = Color(0xFF1A3060);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFC79A3B), Color(0xFFE0BC74), Color(0xFFC79A3B)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF020B18), Color(0xFF071B3B)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF020B18), Color(0xFF0D2D66), Color(0xFF020B18)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F1F3D), Color(0xFF071B3B)],
  );
}
