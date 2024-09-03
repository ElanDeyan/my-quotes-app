import 'dart:convert';

import 'package:basics/basics.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import '../fixtures/tag_extension.dart';
import 'package:my_quotes/services/parse_backup_file.dart';
import 'package:share_plus/share_plus.dart';

import '../fixtures/generate_backup_file_content.dart';
import '../fixtures/generate_random_quote.dart';
import '../fixtures/generate_random_tag.dart';

XFile _getSampleFile(Map<String, Object?> data) =>
    XFile.fromData(utf8.encode(jsonEncode(data)));

const _nonMapValues = [
  1,
  "string",
  [1, 2, 3, 4, 5, 6],
  [
    ["1", "tagName"],
  ],
  true,
  1.755,
];

void _expectQuoteJsonShapeAndTypes(Map<String, Object?> json) {
  expect(json.containsKey('id'), isTrue);
  expect(json.get('id'), isA<int>());

  expect(json.containsKey('content'), isTrue);
  expect(json.get('content'), isA<String>());

  expect(json.containsKey('author'), isTrue);
  expect(json.get('author'), isA<String>());

  expect(json.containsKey('source'), isTrue);
  expect(json.get('source'), isA<String?>());

  expect(json.containsKey('sourceUri'), isTrue);
  expect(json.get('sourceUri'), isA<String?>());

  expect(json.containsKey('isFavorite'), isTrue);
  expect(json.get('isFavorite'), isA<bool>());

  expect(json.containsKey('createdAt'), isTrue);
  expect(json.get('createdAt'), isA<int>());

  expect(json.containsKey('tags'), isTrue);
  expect(json.get('tags'), isA<String?>());
}

void main() {
  late List<Map<String, Object?>> tagsSample;
  late List<Map<String, Object?>> quotesSample;
  setUp(() {
    tagsSample = [
      for (var i = 0; i < 10; i++)
        generateRandomTag().copyWith(id: Value(i + 1)).asIdNamePair,
    ];

    quotesSample = [
      for (var i = 0; i < 10; i++)
        generateRandomQuote()
            .copyWith(
              id: Value(i + 1),
              tags: Value(
                tagsSample.take(3).map((item) => item.keys.single).join(','),
              ),
            )
            .toJson(),
    ];
  });

  test('With generateBackupFileContent', () {
    final correctSample = generateBackupFileContent(
      tags: tagsSample,
      quotes: quotesSample,
    );
    final sampleFile = _getSampleFile(correctSample);

    expect(parseBackupFile(sampleFile), completion(isA<BackupData>()));
  });

  test('Data mantains intact', () async {
    final correctSample = generateBackupFileContent(
      tags: tagsSample,
      quotes: quotesSample,
    );
    final sampleFile = _getSampleFile(correctSample);

    final backupData = await parseBackupFile(sampleFile);

    expect(
      backupData,
      isNotNull,
    );

    expect(
      backupData!.userPreferencesData.themeMode,
      equals(
        (correctSample['preferences']! as Map<String, Object?>)['themeMode'],
      ),
    );

    expect(
      backupData.userPreferencesData.colorPalette,
      equals(
        (correctSample['preferences']! as Map<String, Object?>)['colorPalette'],
      ),
    );

    expect(
      backupData.userPreferencesData.language,
      equals(
        (correctSample['preferences']! as Map<String, Object?>)['language'],
      ),
    );

    expect(
      backupData.tags.map((tag) => tag.asIdNamePair),
      containsAll(tagsSample),
    );

    expect(
      backupData.quotes.map((quote) => quote.toJson()),
      containsAll(quotesSample),
    );
  });

  group('Validating user preferences', () {
    test('Without preferences', () async {
      final sample = generateBackupFileContent(
        preferences: false,
        tags: tagsSample,
        quotes: quotesSample,
      );
      expect(sample.containsKey('preferences'), isFalse);

      final sampleFile = _getSampleFile(sample);

      expect(parseBackupFile(sampleFile), completion(isNull));
    });

    test('Without theme mode', () {
      final sample = generateBackupFileContent(
        themeMode: false,
        tags: tagsSample,
        quotes: quotesSample,
      );
      expect(sample.containsKey('themeMode'), isFalse);

      final sampleFile = _getSampleFile(sample);

      expect(parseBackupFile(sampleFile), completion(isNull));
    });

    test('With wrong theme mode', () async {
      final sample = generateBackupFileContent(
        themeMode: 'false',
        tags: tagsSample,
        quotes: quotesSample,
      );

      final sampleFile = _getSampleFile(sample);

      await expectLater(parseBackupFile(sampleFile), completion(isNull));
    });

    test('Without color palette', () {
      final sample = generateBackupFileContent(
        colorPalette: false,
        tags: tagsSample,
        quotes: quotesSample,
      );
      expect(sample.containsKey('colorPalette'), isFalse);

      final sampleFile = _getSampleFile(sample);

      expect(parseBackupFile(sampleFile), completion(isNull));
    });

    test('With wrong color scheme palette', () async {
      final sample = generateBackupFileContent(
        colorPalette: 'false',
        tags: tagsSample,
        quotes: quotesSample,
      );

      final sampleFile = _getSampleFile(sample);

      await expectLater(parseBackupFile(sampleFile), completion(isNull));
    });

    test('Without language', () {
      final sample = generateBackupFileContent(
        language: false,
        tags: tagsSample,
        quotes: quotesSample,
      );
      expect(sample.containsKey('language'), isFalse);

      final sampleFile = _getSampleFile(sample);

      expect(parseBackupFile(sampleFile), completion(isNull));
    });

    test('With wrong language', () async {
      final sample = generateBackupFileContent(
        language: 'false',
        tags: tagsSample,
        quotes: quotesSample,
      );

      final sampleFile = _getSampleFile(sample);

      await expectLater(parseBackupFile(sampleFile), completion(isNull));
    });
  });

  group('Validating tags data', () {
    test('Without tags', () {
      final sample = generateBackupFileContent(
        tags: false,
        quotes: quotesSample,
      );
      expect(sample.containsKey('tags'), isFalse);

      final sampleFile = _getSampleFile(sample);

      expect(parseBackupFile(sampleFile), completion(isNull));
    });

    test('Not a list of maps', () {
      for (final notMapValue in _nonMapValues) {
        final sample = generateBackupFileContent(
          tags: notMapValue,
          quotes: quotesSample,
        );

        expect(parseBackupFile(_getSampleFile(sample)), completion(isNull));
      }
    });
    test('Has one key', () {
      final sample = generateBackupFileContent(
        tags: [
          {"1": "tagName", "2": "invalidKey"},
          {"3": "tagName", "4": "invalidKey"},
        ],
        quotes: quotesSample,
      );

      expect(parseBackupFile(_getSampleFile(sample)), completion(isNull));
    });

    test('Key is an int', () {
      final sample = generateBackupFileContent(
        tags: [
          {"a": "invalidKey"},
          {"null": "invalidKey"},
          {"b": "invalidKey"},
          {"true": "invalidKey"},
        ],
        quotes: quotesSample,
      );

      expect(parseBackupFile(_getSampleFile(sample)), completion(isNull));
    });

    test('Keys are uniques', () {
      final sample = generateBackupFileContent(
        tags: [
          {"1": "tagName"}, {"3": "tagName"},
          {"2": "tagName"}, {"3": "invalidKey"}, // repeated
        ],
        quotes: quotesSample,
      );

      expect(parseBackupFile(_getSampleFile(sample)), completion(isNull));
    });

    test('Values are String', () {
      final sample = generateBackupFileContent(
        tags: [
          {"1": "tagName"},
          {"3": 56},
          {"2": null},
          {"4": true},
        ],
        quotes: quotesSample,
      );

      expect(parseBackupFile(_getSampleFile(sample)), completion(isNull));
    });
  });

  group('Validating quotes data', () {
    test('Without quotes', () {
      final sample = generateBackupFileContent(
        tags: tagsSample,
        quotes: false,
      );
      expect(sample.containsKey('quotes'), isFalse);

      final sampleFile = _getSampleFile(sample);

      expect(parseBackupFile(sampleFile), completion(isNull));
    });

    test('Items should be Map<String, Object?>', () {
      final sample = generateBackupFileContent(
        tags: tagsSample,
        quotes: _nonMapValues,
      );

      expect(parseBackupFile(_getSampleFile(sample)), completion(isNull));
    });

    test('Items should have unique id', () {
      final sample = generateBackupFileContent(
        tags: tagsSample,
        quotes: quotesSample..add(quotesSample.last),
      );

      expectLater(parseBackupFile(_getSampleFile(sample)), completion(isNull));
    });

    test('Items should case fields and types', () {
      for (final quoteSample in quotesSample) {
        _expectQuoteJsonShapeAndTypes(quoteSample);
      }

      final sample = generateBackupFileContent(
        tags: tagsSample,
        quotes: quotesSample,
      );

      expectLater(
        parseBackupFile(_getSampleFile(sample)),
        completion(isA<BackupData>()),
      );
    });
  });
}
