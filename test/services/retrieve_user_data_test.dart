import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import '../fixtures/list_extension.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/repository/user_preferences.dart';
import 'package:my_quotes/repository/user_preferences_interfaces.dart';
import 'package:my_quotes/services/generate_backup_file.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:my_quotes/states/database_provider.dart';

import '../fixtures/generate_random_quote.dart';
import '../fixtures/generate_random_tag.dart';

const themeModeKey = ThemeModeRepository.themeModeKey;
const defaultThemeMode = ThemeModeRepository.defaultThemeMode;

const colorSchemePaletteKey =
    ColorSchemePaletteRepository.colorSchemePaletteKey;
const defaultColorSchemePalette =
    ColorSchemePaletteRepository.defaultColorSchemePalette;

const languageKey = LanguageRepository.languageKey;
final defaultLanguage = LanguageRepository.defaultLanguage;

void _expectUserDataStructure(Map<String, Object?> userData) {
  expect(userData.containsKey('preferences'), isTrue);
  expect(userData.containsKey('tags'), isTrue);
  expect(userData.containsKey('quotes'), isTrue);

  expect(userData['preferences'], isA<Map<String, Object?>>());
  expect(userData['tags'], isA<List<dynamic>>());
  expect(userData['quotes'], isA<List<dynamic>>());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const numberOfTagsToAdd = 5;
  const numberOfQuotesToAdd = 10;

  late AppRepository appRepository;
  late AppPreferences appPreferences;
  late DatabaseProvider databaseProvider;

  late List<Tag> sampleTags;
  late List<Quote> sampleQuotesWithTags;
  setUp(() {
    final inMemory = DatabaseConnection(NativeDatabase.memory());
    appRepository = AppDatabase.forTesting(inMemory);

    appPreferences =
        AppPreferences(userPreferencesRepository: const UserPreferences());
    databaseProvider = DatabaseProvider(appRepository: appRepository);

    sampleTags = [
      for (var i = 0; i < numberOfTagsToAdd; i++)
        generateRandomTag().copyWith(id: Value(i + 1)),
    ];

    sampleQuotesWithTags = [
      for (var i = 0; i < numberOfQuotesToAdd; i++)
        generateRandomQuote().copyWith(
          id: Value(i + 1),
          tags: Value(
            sampleTags.toShuffledView.take(3).join(idSeparatorChar),
          ),
        ),
    ];
  });

  tearDown(() {
    (appRepository as AppDatabase).close();
  });

  group('Retrieving user data > ', () {
    test('Without changes', () async {
      expect(await databaseProvider.allQuotes, isEmpty);
      expect(await databaseProvider.allTags, isEmpty);

      final userData = await retrieveUserData(appPreferences, databaseProvider);

      _expectUserDataStructure(userData);

      expect(
        (userData['preferences']! as Map<String, Object?>)[themeModeKey],
        equals(defaultThemeMode.name),
      );
      expect(
        (userData['preferences']!
            as Map<String, Object?>)[colorSchemePaletteKey],
        equals(defaultColorSchemePalette.storageName),
      );
      expect(
        (userData['preferences']! as Map<String, Object?>)[languageKey],
        equals(defaultLanguage.languageCode),
      );

      expect(userData['tags'], isEmpty);
      expect(userData['quotes'], isEmpty);
    });

    test('Retrieving user data', () async {
      for (final tag in sampleTags) {
        await appRepository.createTag(tag.name);
      }

      for (final quote in sampleQuotesWithTags) {
        await appRepository.createQuote(quote);
      }

      expect(await databaseProvider.allQuotes, hasLength(numberOfQuotesToAdd));
      expect(await databaseProvider.allTags, hasLength(numberOfTagsToAdd));

      final userData = await retrieveUserData(appPreferences, databaseProvider);

      _expectUserDataStructure(userData);

      final tagsAsIdNameMap = (await databaseProvider.allTags)
          .map((tag) => {'${tag.id}': tag.name});

      expect(userData['tags'], equals(tagsAsIdNameMap));

      final quotesAsJson =
          (await databaseProvider.allQuotes).map((quote) => quote.toJson());

      expect(userData['quotes'], quotesAsJson);
    });
  });
}
