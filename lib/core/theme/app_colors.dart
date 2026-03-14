import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5A52D5);
  static const Color primaryLight = Color(0xFF8B85FF);

  // Background Colors
  static const Color background = Color(0xFF0F0F0F);
  static const Color backgroundLight = Color(0xFF1A1A1A);
  static const Color backgroundLighter = Color(0xFF2A2A2A);

  // Surface Colors
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFF2D2D2D);
  static const Color surfaceDark = Color(0xFF141414);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textTertiary = Color(0xFF808080);
  static const Color textDisabled = Color(0xFF666666);

  // Accent Colors
  static const Color accent = Color(0xFF00D4AA);
  static const Color accentDark = Color(0xFF00B894);
  static const Color accentLight = Color(0xFF00F5C4);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  static const Color overlayDark = Color(0xCC000000);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF6C63FF),
    Color(0xFF00D4AA),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF1A1A1A),
    Color(0xFF0F0F0F),
  ];

  // Category Colors
  static const Color liveColor = Color(0xFFFF4757);
  static const Color vodColor = Color(0xFF2ED573);
  static const Color seriesColor = Color(0xFF1E90FF);
  static const Color favoriteColor = Color(0xFFFF6348);

  // EPG Colors
  static const Color epgCurrent = Color(0xFF6C63FF);
  static const Color epgPast = Color(0xFF666666);
  static const Color epgFuture = Color(0xFFB3B3B3);
}
