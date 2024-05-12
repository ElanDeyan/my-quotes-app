import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_quotes/constants/color_pallete.dart';
import 'package:my_quotes/helpers/string_to_color_pallete.dart';
import 'package:my_quotes/helpers/string_to_theme_mode.dart';
import 'package:my_quotes/repository/user_preferences_interfaces.dart';

final class AppPreferences extends ChangeNotifier {
  AppPreferences({required UserPreferencesRepository userPreferencesRepository})
      : _userPreferencesRepository = userPreferencesRepository,
        _themeMode = ThemeModeRepository.defaultThemeMode,
        _colorPallete = ColorPalleteRepository.defaultColorPallete,
        _language = LanguageRepository.defaultLanguage {
    scheduleMicrotask(loadLocalPreferences);
  }

  final UserPreferencesRepository _userPreferencesRepository;

  Future<void> loadLocalPreferences() async {
    _themeMode = ThemeModeExtension.themeModeFromString(
      await _userPreferencesRepository.themeMode,
    );
    _colorPallete = ColorPalleteExtension.colorPalleteFromString(
      await _userPreferencesRepository.colorPallete,
    );
    _language = await _userPreferencesRepository.language;
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

  ColorPallete _colorPallete;

  ColorPallete get colorPallete => _colorPallete;

  set colorPallete(ColorPallete colorPallete) {
    _colorPallete = colorPallete;

    scheduleMicrotask(() {
      _userPreferencesRepository.setColorPallete(_colorPallete.name);
    });

    notifyListeners();
  }
}
