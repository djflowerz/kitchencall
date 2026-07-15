import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized typography. Styles are computed as getters (not fixed
/// fields) so they pick up [brightness] whenever it changes — set
/// [brightness] once per frame from `KitchenCallApp.build` and every
/// screen's text automatically follows the active theme, without each
/// of the ~50 screens needing to look up `Theme.of(context)` itself.
class AppTextStyles {
  AppTextStyles._();

  static Brightness brightness = Brightness.light;
  static bool get _isDark => brightness == Brightness.dark;

  static Color get _primaryText => _isDark ? AppColors.darkTextPrimary : AppColors.textDark;
  static Color get _mutedText => _isDark ? AppColors.darkTextMuted : AppColors.textMuted;

  static final TextStyle _base = GoogleFonts.poppins();

  static TextStyle get h1 => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: _primaryText,
        height: 1.2,
      );

  static TextStyle get h2 => _base.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: _primaryText,
        height: 1.25,
      );

  static TextStyle get h3 => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: _primaryText,
      );

  static TextStyle get bodyLarge => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: _primaryText,
      );

  static TextStyle get bodyMedium => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _primaryText,
      );

  static TextStyle get bodySmall => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: _mutedText,
      );

  static TextStyle get button => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get caption => _base.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: _mutedText,
      );

  static TextStyle get price => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryGreen,
      );
}
