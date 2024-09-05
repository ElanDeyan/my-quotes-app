import 'package:flutter/material.dart';

abstract interface class ThemeModeRepository {
  static const themeModeKey = 'themeMode';

  static const defaultThemeMode = ThemeMode.system;

  static const values = ThemeMode.values;

  Future<String> get themeMode;

  Future<void> setThemeMode(String themeMode);
}
