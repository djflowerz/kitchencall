import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_text_styles.dart';
import 'core/constants/app_constants.dart';
import 'providers/theme_provider.dart';

class KitchenCallApp extends ConsumerWidget {
  const KitchenCallApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    // Resolve the *actual* brightness (accounting for ThemeMode.system)
    // so AppTextStyles' getters return the right colors before the
    // MaterialApp itself has finished applying the theme to descendants.
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    AppTextStyles.brightness = switch (themeMode) {
      ThemeMode.dark => Brightness.dark,
      ThemeMode.light => Brightness.light,
      ThemeMode.system => platformBrightness,
    };

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
