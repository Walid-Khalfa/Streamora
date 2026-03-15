import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color accent = Color(0xFF06B6D4);

  // Background Colors
  static const Color backgroundDark = Color(0xFF0F0F0F);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF262626);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFA1A1AA);
  static const Color textTertiaryDark = Color(0xFF71717A);
  static const Color textPrimaryLight = Color(0xFF18181B);
  static const Color textSecondaryLight = Color(0xFF52525B);
  static const Color textTertiaryLight = Color(0xFF71717A);

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Live Indicator
  static const Color liveRed = Color(0xFFEF4444);
  static const Color livePulse = Color(0xFFDC2626);

  // VOD/Series Indicators
  static const Color vodIndicator = Color(0xFF8B5CF6);
  static const Color seriesIndicator = Color(0xFF06B6D4);

  // Grayscale
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF4F4F5);
  static const Color gray200 = Color(0xFFE4E4E7);
  static const Color gray300 = Color(0xFFD4D4D8);
  static const Color gray400 = Color(0xFFA1A1AA);
  static const Color gray500 = Color(0xFF71717A);
  static const Color gray600 = Color(0xFF52525B);
  static const Color gray700 = Color(0xFF3F3F46);
  static const Color gray800 = Color(0xFF27272A);
  static const Color gray900 = Color(0xFF18181B);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, accent],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, backgroundDark],
  );
}
