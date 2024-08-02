import 'dart:convert';

import 'package:basics/basics.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_quotes/constants/enums/color_scheme_palette.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/repository/user_preferences.dart';
import 'package:my_quotes/repository/user_preferences_interfaces.dart';
import 'package:my_quotes/services/generate_backup_file.dart';
import 'package:my_quotes/services/parse_backup_file.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:my_quotes/states/database_provider.dart';

import '../fixtures/generate_random_quote.dart';
import '../fixtures/generate_random_tag.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppRepository appRepository;
  late AppPreferences appPreferences;
  late DatabaseProvider databaseProvider;

  late List<Tag> tagsSample;
  late List<Quote> quotesSample;

  setUp(() {
    final inMemory = DatabaseConnection(NativeDatabase.memory());
    appRepository = AppDatabase.forTesting(inMemory);

    appPreferences =
        AppPreferences(userPreferencesRepository: const UserPreferences());

    databaseProvider = DatabaseProvider(appRepository: appRepository);

    tagsSample = [
      for (var i = 0; i < 10; i++)
        generateRandomTag().copyWith(id: Value(i + 1)),
    ];

    quotesSample = [
      for (var i = 0; i < 10; i++)
        generateRandomQuote().copyWith(
          id: Value(i + 1),
          tags: Value(
            tagsSample.take(3).map((item) => item.id!).join(','),
          ),
        ),
    ];
  });

  tearDown(() {
    (appRepository as AppDatabase).close();
  });

  test('Is json', () async {
    final backupFile =
        await generateBackupFile(databaseProvider, appPreferences);
    expect(
      jsonDecode(utf8.decode(await backupFile.readAsBytes())),
      isA<Map<String, Object?>>(),
    );
  });

  group('Generating and parsing > ', () {
    late ThemeMode sampleThemeMode;
    late ColorSchemePalette sampleColorSchemePalette;
    late String sampleLanguage;

    setUp(() {
      sampleThemeMode = ThemeModeRepository.values.getRandom()!;
      sampleColorSchemePalette =
          ColorSchemePaletteRepository.values.getRandom()!;
      sampleLanguage = LanguageRepository.values.getRandom()!;
    });

    test('Generated file is correctly parsed', () async {
      final backupFile =
          await generateBackupFile(databaseProvider, appPreferences);

      await expectLater(
        parseBackupFile(backupFile),
        completion(isA<BackupData>()),
      );
    });

    test('Adding quotes and tags', () async {
      await expectLater(appRepository.allQuotes, completion(isEmpty));
      await expectLater(appRepository.allTags, completion(isEmpty));

      expect(
        appPreferences.themeMode,
        ThemeModeRepository.defaultThemeMode,
      );
      expect(
        appPreferences.colorSchemePalette,
        ColorSchemePaletteRepository.defaultColorSchemePalette,
      );
      expect(
        appPreferences.language,
        LanguageRepository.defaultLanguage.languageCode,
      );

      tagsSample.map((tag) => tag.name).forEach(appRepository.createTag);
      quotesSample.forEach(appRepository.createQuote);

      appPreferences.themeMode = sampleThemeMode;
      appPreferences.colorSchemePalette = sampleColorSchemePalette;
      appPreferences.language = sampleLanguage;

      final backupFile =
          await generateBackupFile(databaseProvider, appPreferences);
      final parsedData = await parseBackupFile(backupFile);

      expect(parsedData, isNotNull);

      expect(
        parsedData!.userPreferencesData.themeMode,
        equals(sampleThemeMode.name),
      );
      expect(
        parsedData.userPreferencesData.colorPalette,
        equals(sampleColorSchemePalette.storageName),
      );
      expect(
        parsedData.userPreferencesData.language,
        equals(sampleLanguage),
      );
      expect(parsedData.quotes, orderedEquals(quotesSample));
      expect(parsedData.tags, orderedEquals(tagsSample));
    });
  });
}
