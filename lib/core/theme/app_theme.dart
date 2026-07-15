import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Extra surface colors that Material's [ColorScheme] doesn't cover
/// 1:1 (our specific `surface`/`border`/`divider` shades). Custom
/// containers across the app read these via `context.surfaceColors`
/// instead of hardcoding [AppColors.surface] etc., so they follow
/// light/dark mode automatically.
class SurfaceColors extends ThemeExtension<SurfaceColors> {
  const SurfaceColors({required this.surface, required this.border, required this.divider});
  final Color surface;
  final Color border;
  final Color divider;

  static const light = SurfaceColors(surface: AppColors.surface, border: AppColors.border, divider: AppColors.divider);
  static const dark = SurfaceColors(surface: AppColors.darkSurface, border: AppColors.darkBorder, divider: AppColors.darkDivider);

  @override
  SurfaceColors copyWith({Color? surface, Color? border, Color? divider}) {
    return SurfaceColors(
      surface: surface ?? this.surface,
      border: border ?? this.border,
      divider: divider ?? this.divider,
    );
  }

  @override
  SurfaceColors lerp(ThemeExtension<SurfaceColors>? other, double t) {
    if (other is! SurfaceColors) return this;
    return SurfaceColors(
      surface: Color.lerp(surface, other.surface, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}

extension SurfaceColorsX on BuildContext {
  SurfaceColors get surfaceColors => Theme.of(this).extension<SurfaceColors>() ?? SurfaceColors.light;
}

class AppTheme {
  AppTheme._();

  static const double radius = 16.0;

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background = isDark ? AppColors.darkBackground : AppColors.background;
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final divider = isDark ? AppColors.darkDivider : AppColors.divider;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textDark;
    final mutedText = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      primaryColor: AppColors.primaryGreen,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        brightness: brightness,
        primary: AppColors.primaryGreen,
        secondary: AppColors.secondaryOrange,
        surface: surface,
        error: AppColors.error,
      ),
      extensions: [isDark ? SurfaceColors.dark : SurfaceColors.light],
      fontFamily: AppTextStyles.bodyMedium.fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: AppTextStyles.h3,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: divider),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: AppTextStyles.button,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.primaryGreen),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primaryGreen),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: mutedText),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: mutedText,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(color: divider, thickness: 1),
      listTileTheme: ListTileThemeData(iconColor: textColor, textColor: textColor),
      dialogTheme: DialogThemeData(backgroundColor: surface, surfaceTintColor: Colors.transparent),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: surface, surfaceTintColor: Colors.transparent),
      popupMenuTheme: PopupMenuThemeData(color: surface),
    );
  }
}
