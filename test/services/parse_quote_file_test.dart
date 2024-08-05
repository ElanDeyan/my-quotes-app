import 'dart:convert';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/services/parse_quote_file.dart';
import 'package:share_plus/share_plus.dart';

import '../fixtures/generate_random_quote.dart';

void main() {
  late Quote quote;
  late Map<String, Object?> quoteAsJson;
  late XFile quoteFile;
  const sampleTagName = 'tech';

  setUp(() {
    quote = generateRandomQuote(
      generateId: true,
    ).copyWith(tags: const Value(sampleTagName));

    // usually, should be tag ID, but for this test I'll use the tag name
    quoteAsJson = quote.toJson()
      ..update(
        'tags',
        (value) => (value as String?)?.split(','),
        ifAbsent: () => null,
      );

    quoteFile = XFile.fromData(utf8.encode(jsonEncode(quoteAsJson)));
  });

  test('Non-json files', () async {
    final randomContent = random.string(100, min: 50);
    final sampleWrongFile = XFile.fromData(utf8.encode(randomContent));

    await expectLater(parseQuoteFile(sampleWrongFile), completion(isNull));
  });

  group('Quote and tags data', () {
    test('Quotes should have null in tags field', () async {
      await expectLater(
        parseQuoteFile(quoteFile),
        completion(isA<QuoteAndTags>()),
      );
      final (quote: quoteData, tags: _) = (await parseQuoteFile(quoteFile))!;
      expect(quoteData.tags, isNull);
    });

    test('Tags (if have in original quote) should appear in tags', () async {
      expect(
        quoteAsJson['tags'],
        allOf([
          isNotNull,
          containsAll([sampleTagName]),
        ]),
      );

      final (quote: quoteFromParsing, :tags) =
          (await parseQuoteFile(quoteFile))!;

      expect(quoteFromParsing.tags, isNull);
      expect(tags, containsAll([sampleTagName]));
    });

    test('Non-string tags data will be stringfied', () async {
      final sampleNonStringData = [
        1,
        true,
        null,
        ['oi', 'hello'],
      ];

      quoteAsJson.update(
        'tags',
        (value) => sampleNonStringData,
        ifAbsent: () => sampleNonStringData,
      );

      quoteFile = XFile.fromData(utf8.encode(jsonEncode(quoteAsJson)));

      final (quote: _, :tags) = (await parseQuoteFile(quoteFile))!;

      expect(
        tags,
        hasLength(sampleNonStringData.length),
        reason: 'Proofs that none element was discarded',
      );

      expect(
        tags,
        containsAll(sampleNonStringData.map((item) => item.toString())),
      );
    });
  });
}
