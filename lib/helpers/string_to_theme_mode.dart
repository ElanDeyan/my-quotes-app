import 'package:flutter/material.dart';

extension ThemeModeExtension on ThemeMode {
  static ThemeMode themeModeFromString(String string) {
    const themeModeValues = ThemeMode.values;

    for (final themeMode in themeModeValues) {
      if (string.toLowerCase().compareTo(themeMode.name.toLowerCase()) == 0) {
        return themeMode;
      }
    }

    throw ArgumentError.value(string, null, 'Invalid theme mode name');
  }
}
