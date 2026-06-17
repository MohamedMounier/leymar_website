import 'package:flutter/material.dart';

/// Yelmar — Light Luxury palette.
/// Warm ivory canvas, deep royal-navy ink, antique-gold accents.
/// Derived from the logo: navy jacquard + gold loom + serif gold wordmark.
class AppColors {
  AppColors._();

  // ── Surfaces ──────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFFBF8F2); // warm porcelain ivory
  static const Color surfaceAlt = Color(0xFFF3ECDF); // deeper champagne sand
  static const Color cardColor = Color(0xFFFFFFFF); // pristine white card

  // ── Brand (navy) ──────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF0D2D66); // deep sapphire
  static const Color primaryDark = Color(0xFF071B3B); // royal midnight
  static const Color secondary = Color(0xFF14377A); // mid sapphire

  // ── Gold ──────────────────────────────────────────────────────────────────
  static const Color accent = Color(0xFFA9781E); // deep antique gold (text-safe)
  static const Color gold = Color(0xFFC79A3B); // brand gold (metallic fills)
  static const Color highlight = Color(0xFFE0BC74); // champagne highlight

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0B1E3F); // deep navy ink
  static const Color textSecondary = Color(0xFF55607A); // slate
  static const Color textMuted = Color(0xFF9A958C); // warm muted gray

  // ── Lines ─────────────────────────────────────────────────────────────────
  static const Color divider = Color(0xFFE7DFCF); // warm hairline

  // ── Gradients ───────────────────────────────────────────────────────────────
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFC79A3B), Color(0xFFE0BC74), Color(0xFFC79A3B)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFDF9), Color(0xFFF3ECDF)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFDF9), Color(0xFFF1E8D6), Color(0xFFFBF8F2)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFFBF6EC)],
  );

  /// Subtle ivory section wash for full-width bands.
  static const LinearGradient sectionGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFBF8F2), Color(0xFFF4EDE0), Color(0xFFFBF8F2)],
    stops: [0.0, 0.5, 1.0],
  );

  /// Deep navy band — used sparingly as a luxe feature strip / footer.
  static const LinearGradient navyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D2D66), Color(0xFF071B3B)],
  );
}
