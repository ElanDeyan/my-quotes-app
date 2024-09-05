import 'dart:async';
import 'dart:convert';

import 'package:my_quotes/repository/interfaces/app_repository.dart';
import 'package:my_quotes/repository/interfaces/color_scheme_palette_repository.dart';
import 'package:my_quotes/repository/interfaces/language_repository.dart';
import 'package:my_quotes/repository/interfaces/theme_mode_repository.dart';
import 'package:my_quotes/repository/interfaces/user_preferences_interfaces.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:share_plus/share_plus.dart';

Future<XFile> generateBackupFile(
  AppRepository appRepository,
  AppPreferences appPreferences,
) async {
  final userData = await retrieveUserData(appPreferences, appRepository);

  final encodedData = utf8.encode(jsonEncode(userData));

  return XFile.fromData(encodedData);
}

Future<Map<String, Object?>> retrieveUserData(
  AppPreferences appPreferences,
  AppRepository appRepository,
) async {
  final tags = await appRepository.allTags;

  final quotes = await appRepository.allQuotes;

  final colorPalette = appPreferences.colorSchemePalette;

  final themeMode = appPreferences.themeMode;

  final language = appPreferences.language;

  final backupData = <String, dynamic>{
    "preferences": <String, String>{
      ThemeModeRepository.themeModeKey: themeMode.name,
      ColorSchemePaletteRepository.colorSchemePaletteKey:
          colorPalette.storageName,
      LanguageRepository.languageKey: language,
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
