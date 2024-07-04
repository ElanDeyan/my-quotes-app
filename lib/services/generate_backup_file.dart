import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_quotes/repository/user_preferences_interfaces.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

Future<XFile?> generateBackupFile(BuildContext context) async {
  if (context.mounted) {
    final userData = await retrieveUserData(context);

    final encodedData = utf8.encode(jsonEncode(userData));

    return XFile.fromData(encodedData);
  }
  return null;
}

Future<Map<String, dynamic>> retrieveUserData(BuildContext context) async {
  final database = Provider.of<DatabaseProvider>(context, listen: false);

  final appPreferences = Provider.of<AppPreferences>(context, listen: false);
  final tags = await database.allTags;

  final quotes = await database.allQuotes;

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
      for (final tag in tags) <String, String>{"${tag.id!}": tag.name},
    ],
    "quotes": [
      for (final quote in quotes) quote.toJson(),
    ],
  };

  return backupData;
}
