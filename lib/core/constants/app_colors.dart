import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors (Electric Azure & Royal Indigo)
  static const Color primary = Color(0xFF2563EB);       // Vivid Electric Azure
  static const Color primaryLight = Color(0xFFEFF6FF);  // Soft Azure Glow
  static const Color primaryDark = Color(0xFF1D4ED8);   // Deep Royal Azure

  // Light Mode Surfaces & Backgrounds
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Dark Mode Surfaces & Backgrounds (Deep Midnight Obsidian)
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF131B2E);
  static const Color darkSurfaceVariant = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF26334D);

  // Fallback defaults for backwards compatibility
  static const Color background = lightBackground;
  static const Color surface = lightSurface;
  static const Color surfaceVariant = lightSurfaceVariant;
  static const Color border = lightBorder;

  // Text Colors - Light Mode
  static const Color textPrimary = Color(0xFF0F172A);   // Rich Obsidian Slate
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF94A3B8);     // Slate 400

  // Text Colors - Dark Mode
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Macro Nutrient Accent Colors
  static const Color protein = Color(0xFF38BDF8); // Cool Sky Blue (Luminous in both modes)
  static const Color carbs = Color(0xFFF59E0B);   // Radiant Amber
  static const Color fat = Color(0xFF10B981);     // Fresh Emerald

  // Sun and Moon Theme Accents
  static const Color sunAmber = Color(0xFFF59E0B);
  static const Color moonIndigo = Color(0xFF818CF8);

  // Status & Utility Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFEAB308);
  static const Color error = Color(0xFFEF4444);

  // Dynamic Theme Helpers
  static Color bg(bool isDark) => isDark ? darkBackground : lightBackground;
  static Color card(bool isDark) => isDark ? darkSurface : lightSurface;
  static Color cardVariant(bool isDark) => isDark ? darkSurfaceVariant : lightSurfaceVariant;
  static Color brd(bool isDark) => isDark ? darkBorder : lightBorder;
  static Color txtPrimary(bool isDark) => isDark ? darkTextPrimary : textPrimary;
  static Color txtSecondary(bool isDark) => isDark ? darkTextSecondary : textSecondary;
  static Color txtMuted(bool isDark) => isDark ? darkTextMuted : textMuted;
  static Color primaryGlow(bool isDark) => isDark ? const Color(0xFF1E293B) : primaryLight;
}
