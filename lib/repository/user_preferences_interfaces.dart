import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/constants/enums/color_scheme_palette.dart';

abstract interface class UserPreferencesRepository
    implements
        LanguageRepository,
        ColorSchemePaletteRepository,
        ThemeModeRepository {}

abstract interface class ColorSchemePaletteRepository {
  static const colorSchemePaletteKey = 'colorPalette';

  static const defaultColorSchemePalette = ColorSchemePalette.blue;

  Future<String> get colorSchemePalette;

  Future<bool> setColorSchemePalette(String colorSchemePalette);
}

abstract interface class LanguageRepository {
  static const languageKey = 'language';

  static final defaultLanguage = AppLocalizations.supportedLocales
      .where((element) => element == const Locale('en'))
      .single;

  Future<String> get language;

  Future<bool> setLanguage(String language);
}

abstract interface class ThemeModeRepository {
  static const themeModeKey = 'themeMode';

  static const defaultThemeMode = ThemeMode.system;

  Future<String> get themeMode;

  Future<bool> setThemeMode(String themeMode);
}
