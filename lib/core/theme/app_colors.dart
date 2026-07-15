import 'package:flutter/material.dart';

/// KitchenCall brand palette.
/// Primary green + secondary orange, per brand guidelines.
class AppColors {
  AppColors._();

  // Brand
  static const Color primaryGreen = Color(0xFF1F7A3D);
  static const Color primaryGreenDark = Color(0xFF14532A);
  static const Color primaryGreenLight = Color(0xFFE8F3EC);
  static const Color secondaryOrange = Color(0xFFF97316);
  static const Color secondaryOrangeLight = Color(0xFFFFF1E6);

  // Neutrals
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF222222);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFEFEFEF);

  // Status
  static const Color success = Color(0xFF1F7A3D);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);
  static const Color starGold = Color(0xFFFBBF24);

  // Status badges (bookings/orders)
  static const Color statusUpcoming = Color(0xFF2563EB);
  static const Color statusInProgress = Color(0xFFF97316);
  static const Color statusCompleted = Color(0xFF1F7A3D);
  static const Color statusCancelled = Color(0xFFDC2626);
  static const Color statusPending = Color(0xFFF59E0B);

  static const List<Color> greenGradient = [
    Color(0xFF1F7A3D),
    Color(0xFF14532A),
  ];

  // Dark theme neutrals — brand green/orange accents stay the same
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextMuted = Color(0xFFA0A0A0);
  static const Color darkBorder = Color(0xFF2C2C2C);
  static const Color darkDivider = Color(0xFF262626);
}
