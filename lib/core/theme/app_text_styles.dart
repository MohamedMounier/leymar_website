
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLarge => GoogleFonts.cormorant(
        fontSize: 80,
        fontWeight: FontWeight.w300,
        color: AppColors.textPrimary,
        letterSpacing: -1,
        height: 1.1,
      );

  static TextStyle get displayMedium => GoogleFonts.cormorant(
        fontSize: 56,
        fontWeight: FontWeight.w300,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle get headlineLarge => GoogleFonts.cormorant(
        fontSize: 40,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineMedium => GoogleFonts.cormorant(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineSmall => GoogleFonts.cormorant(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get titleLarge => GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.3,
      );

  static TextStyle get titleMedium => GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        letterSpacing: 0.2,
      );

  static TextStyle get bodyLarge => GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.7,
      );

  static TextStyle get bodyMedium => GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  static TextStyle get bodySmall => GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.5,
      );

  static TextStyle get labelLarge => GoogleFonts.montserrat(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.accent,
        letterSpacing: 2.5,
      );

  static TextStyle get labelMedium => GoogleFonts.montserrat(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.accent,
        letterSpacing: 2,
      );

  static TextStyle get goldAccent => GoogleFonts.cormorant(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.accent,
        letterSpacing: 1,
      );

  static TextStyle get navItem => GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get logoText => GoogleFonts.cormorant(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.accent,
        letterSpacing: 4,
      );

  static TextStyle get statNumber => GoogleFonts.cormorant(
        fontSize: 64,
        fontWeight: FontWeight.w300,
        color: AppColors.accent,
        height: 1,
      );

  static TextStyle get statLabel => GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 1.5,
      );
}
