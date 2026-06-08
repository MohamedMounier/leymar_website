import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get gold => [
        BoxShadow(
          color: AppColors.accent.withOpacity(0.3),
          blurRadius: 30,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: AppColors.accent.withOpacity(0.12),
          blurRadius: 60,
          spreadRadius: 10,
        ),
      ];

  static List<BoxShadow> get button => [
        BoxShadow(
          color: AppColors.accent.withOpacity(0.4),
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get cardHover => [
        BoxShadow(
          color: AppColors.accent.withOpacity(0.2),
          blurRadius: 40,
          spreadRadius: 3,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.6),
          blurRadius: 30,
          offset: const Offset(0, 15),
        ),
      ];
}
