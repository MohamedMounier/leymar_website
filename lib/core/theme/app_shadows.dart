import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  AppShadows._();

  // Soft navy-tinted elevation that reads as luxury on an ivory canvas.
  static List<BoxShadow> get card => [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.10),
          blurRadius: 28,
          offset: const Offset(0, 12),
        ),
        BoxShadow(
          color: AppColors.primary.withOpacity(0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get gold => [
        BoxShadow(
          color: AppColors.gold.withOpacity(0.28),
          blurRadius: 30,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: AppColors.gold.withOpacity(0.12),
          blurRadius: 60,
          spreadRadius: 8,
        ),
      ];

  static List<BoxShadow> get button => [
        BoxShadow(
          color: AppColors.gold.withOpacity(0.35),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get cardHover => [
        BoxShadow(
          color: AppColors.gold.withOpacity(0.22),
          blurRadius: 38,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: AppColors.primary.withOpacity(0.14),
          blurRadius: 30,
          offset: const Offset(0, 16),
        ),
      ];
}
