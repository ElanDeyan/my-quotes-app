import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_quotes/helpers/tag_extension.dart';
import 'package:my_quotes/services/parse_backup_file.dart';
import 'package:share_plus/share_plus.dart';

import '../fixtures/generate_backup_file_content.dart';
import '../fixtures/generate_random_quote.dart';
import '../fixtures/generate_random_tag.dart';

XFile _getSampleFile(Map<String, dynamic> data) =>
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

void main() {
  late List<Map<String, dynamic>> tagsSample;
  late List<Map<String, dynamic>> quotesSample;
  setUp(() {
    tagsSample = [
      for (var i = 0; i < 10; i++)
        generateRandomTag(generateId: true).asIdNamePair,
    ];

    quotesSample = [
      for (var i = 0; i < 10; i++)
        generateRandomQuote(generateId: true, generateTags: true).toJson(),
    ];
  });

  tearDown(() {});

  test('With generateBackupFile', () {
    final correctSample = generateBackupFileContent(
      tags: tagsSample,
      quotes: quotesSample,
    );
    final sampleFile = _getSampleFile(correctSample);

    expect(parseBackupFile(sampleFile), completion(isA<BackupData>()));
  });

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

  test('Without tags', () {
    final sample = generateBackupFileContent(
      tags: false,
      quotes: quotesSample,
    );
    expect(sample.containsKey('tags'), isFalse);

    final sampleFile = _getSampleFile(sample);

    expect(parseBackupFile(sampleFile), completion(isNull));
  });

  test('Without quotes', () {
    final sample = generateBackupFileContent(
      tags: tagsSample,
      quotes: false,
    );
    expect(sample.containsKey('quotes'), isFalse);

    final sampleFile = _getSampleFile(sample);

    expect(parseBackupFile(sampleFile), completion(isNull));
  });

  group('Validating tags data', () {
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
}
