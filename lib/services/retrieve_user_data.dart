import 'dart:async';

import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/repository/color_scheme_palette_repository.dart';
import 'package:my_quotes/repository/language_repository.dart';
import 'package:my_quotes/repository/secure_repository.dart';
import 'package:my_quotes/repository/theme_mode_repository.dart';
import 'package:my_quotes/states/app_preferences.dart';

Future<Map<String, Object?>> retrieveUserData(
  AppPreferences appPreferences,
  AppRepository appRepository,
  SecureRepository secureRepository,
) async {
  final tags = await appRepository.allTags;

  final quotes = await appRepository.allQuotes;

  final colorPalette = appPreferences.colorSchemePalette;

  final themeMode = appPreferences.themeMode;

  final language = appPreferences.language;

  final allowErrorReporting = await secureRepository.allowErrorReporting;

  final backupData = <String, dynamic>{
    "preferences": <String, String>{
      ThemeModeRepository.themeModeKey: themeMode.name,
      ColorSchemePaletteRepository.colorSchemePaletteKey:
          colorPalette.storageName,
      LanguageRepository.languageKey: language,
      SecureRepository.allowErrorReportingKey: allowErrorReporting.toString(),
    },
    "tags": [
      for (final tag in tags) <String, String>{"${tag.id}": tag.name},
    ],
    "quotes": [
      for (final quote in quotes) quote.toJson(),
    ],
  };

  return backupData;
}
