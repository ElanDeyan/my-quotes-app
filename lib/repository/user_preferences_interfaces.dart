import 'package:flutter/material.dart';
import 'package:my_quotes/constants/color_pallete.dart';

abstract interface class UserPreferencesRepository
    implements
        LanguageRepository,
        ColorPalleteRepository,
        ThemeModeRepository {}

abstract interface class ColorPalleteRepository {
  static const colorPalleteKey = 'colorPallete';

  static const defaultColorPallete = ColorPallete.blue;

  Future<String> get colorPallete;

  Future<bool> setColorPallete(String colorPallete);
}

abstract interface class LanguageRepository {
  static const languageKey = 'language';

  static const defaultLanguage = 'en';

  Future<String> get language;

  Future<bool> setLanguage(String language);
}

abstract interface class ThemeModeRepository {
  static const themeModeKey = 'themeMode';

  static const defaultThemeMode = ThemeMode.system;

  Future<String> get themeMode;

  Future<bool> setThemeMode(String themeMode);
}
