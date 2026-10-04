import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Transpesa Brand Primary & Secondary
  static const Color primary = Color(0xFF0D253F); // Deep Corporate Navy
  static const Color primaryLight = Color(0xFF1E3A5F);
  static const Color primaryDark = Color(0xFF071727);

  static const Color secondary = Color(0xFFE5A910); // Transpesa Gold/Yellow Accent
  static const Color secondaryLight = Color(0xFFFFD54F);
  static const Color secondaryDark = Color(0xFFC48800);

  // Neutral Backgrounds & Surfaces
  static const Color background = Color(0xFFF4F6F9); // Light Gray Background
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEAEFF5);

  // Typography / Text Colors
  static const Color textPrimary = Color(0xFF1A2130);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textLight = Color(0xFFFFFFFF);

  // SUNAT Status Colors
  static const Color sunatAceptado = Color(0xFF10B981); // Emerald Green
  static const Color sunatAceptadoBg = Color(0xFFECFDF5);
  static const Color sunatRechazado = Color(0xFFEF4444); // Crimson Red
  static const Color sunatRechazadoBg = Color(0xFFFEF2F2);
  static const Color sunatPendiente = Color(0xFF6B7280); // Slate Gray / Pending
  static const Color sunatPendienteBg = Color(0xFFF3F4F6);
  static const Color sunatAlerta = Color(0xFFF59E0B); // Amber Warning
  static const Color sunatAlertaBg = Color(0xFFFFFBEB);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color inputBorder = Color(0xFFCBD5E1);

  // State Overlays
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);
}
