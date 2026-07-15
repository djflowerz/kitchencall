import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(ThemeMode.system);

  void setMode(ThemeMode mode) => state = mode;
  void toggleDark(bool isDark) => state = isDark ? ThemeMode.dark : ThemeMode.light;

  // TODO: persist the chosen mode (shared_preferences or your user
  // settings doc in Firestore) so it survives app restarts — currently
  // resets to ThemeMode.system on relaunch.
}

final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>(
  (ref) => ThemeModeController(),
);
