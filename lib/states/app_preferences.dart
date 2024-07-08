import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_quotes/constants/enums/color_scheme_pallete.dart';
import 'package:my_quotes/helpers/string_to_color_pallete.dart';
import 'package:my_quotes/helpers/string_to_theme_mode.dart';
import 'package:my_quotes/repository/user_preferences_interfaces.dart';

final class AppPreferences extends ChangeNotifier {
  AppPreferences({required UserPreferencesRepository userPreferencesRepository})
      : _userPreferencesRepository = userPreferencesRepository,
        _themeMode = ThemeModeRepository.defaultThemeMode,
        _colorSchemePalette =
            ColorSchemePaletteRepository.defaultColorSchemePalette,
        _language = LanguageRepository.defaultLanguage.toString() {
    scheduleMicrotask(loadLocalPreferences);
  }

  final UserPreferencesRepository _userPreferencesRepository;

  Future<void> loadLocalPreferences() async {
    _themeMode = ThemeModeExtension.themeModeFromString(
          await _userPreferencesRepository.themeMode,
        ) ??
        ThemeModeRepository.defaultThemeMode;

    _colorSchemePalette =
        ColorSchemePaletteExtension.colorSchemePaletteFromString(
              await _userPreferencesRepository.colorSchemePalette,
            ) ??
            ColorSchemePaletteRepository.defaultColorSchemePalette;

    _language = await _userPreferencesRepository.language;

    notifyListeners();
  }

  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;

    scheduleMicrotask(() {
      _userPreferencesRepository.setThemeMode(_themeMode.name);
    });

    notifyListeners();
  }

  String _language;

  String get language => _language;

  set language(String language) {
    _language = language;

    scheduleMicrotask(() {
      _userPreferencesRepository.setLanguage(_language);
    });

    notifyListeners();
  }

  ColorSchemePalette _colorSchemePalette;

  ColorSchemePalette get colorSchemePalette => _colorSchemePalette;

  set colorSchemePalette(ColorSchemePalette colorSchemePalette) {
    _colorSchemePalette = colorSchemePalette;

    scheduleMicrotask(() {
      _userPreferencesRepository
          .setColorSchemePalette(_colorSchemePalette.storageName);
    });

    notifyListeners();
  }
}
