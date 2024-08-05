import 'dart:convert';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_quotes/constants/enums/parse_quote_file_errors.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/services/parse_quote_file.dart';
import 'package:share_plus/share_plus.dart';

import '../fixtures/generate_random_quote.dart';

typedef DataWithoutError = ({QuoteAndTags data, void error});
typedef ErrorWithoutData = ({void data, ParseQuoteFileErrors error});
void main() {
  late Quote quote;
  late Map<String, Object?> quoteAsJson;
  late XFile quoteFile;
  const sampleTagsName = ['tech'];

  setUp(() {
    quote = generateRandomQuote(
      generateId: true,
    ).copyWith(tags: Value(sampleTagsName.join(',')));

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

    await expectLater(parseQuoteFile(sampleWrongFile), completes);

    final result = await parseQuoteFile(sampleWrongFile);

    expect(result, isA<ErrorWithoutData>());

    expect(result.data, isNull);
    expect(result.error, equals(ParseQuoteFileErrors.notJsonFormat));
  });

  test('Invalid Json format (list)', () async {
    final content = [quoteAsJson];
    final sampleWrongFile = XFile.fromData(utf8.encode(jsonEncode(content)));

    await expectLater(parseQuoteFile(sampleWrongFile), completes);

    final result = await parseQuoteFile(sampleWrongFile);

    expect(result, isA<ErrorWithoutData>());

    expect(result.data, isNull);
    expect(result.error, equals(ParseQuoteFileErrors.notJsonMap));
  });

  test('Wrong fields', () async {
    final sampleWrongJson = quoteAsJson
        .map((key, value) => MapEntry(key, value))
      ..remove('content');

    final sampleWrongFile =
        XFile.fromData(utf8.encode(jsonEncode(sampleWrongJson)));

    await expectLater(parseQuoteFile(sampleWrongFile), completes);

    final result = await parseQuoteFile(sampleWrongFile);

    expect(result.data, isNull);
    expect(result.error, equals(ParseQuoteFileErrors.notCaseFieldsAndTypes));
  });

  group('Quote and tags data', () {
    test('Correct data', () async {
      await expectLater(
        parseQuoteFile(quoteFile),
        completion(isA<DataWithoutError>()),
      );
    });

    test('Tags (if have in original quote) should appear in tags', () async {
      expect(
        quoteAsJson['tags'],
        allOf([
          isNotNull,
          containsAll(sampleTagsName),
        ]),
      );

      final result = await parseQuoteFile(quoteFile);

      expect(result, isA<DataWithoutError>());

      final (quote: quoteFromParsing, :tags) = result.data!;

      expect(quoteFromParsing.tags, isNull);
      expect(tags, containsAll(sampleTagsName));
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

      final result = await parseQuoteFile(quoteFile);

      expect(result, isA<DataWithoutError>());

      final (quote: _, :tags) = result.data!;

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
