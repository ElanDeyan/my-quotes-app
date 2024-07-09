import 'dart:math';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

Quote _generateRandomQuote({
  bool generateId = false,
  bool generateTags = false,
}) {
  const maxId = 100;
  return Quote(
    id: generateId ? Random().nextInt(maxId) : null,
    content: faker.lorem.sentence(),
    author: faker.person.name(),
    createdAt: faker.date.dateTime(),
    isFavorite: Random().nextBool(),
    source: faker.conference.name(),
    sourceUri: faker.internet.httpsUrl(),
    tags: generateTags
        ? RandomGenerator()
            .amount((_) => Random().nextInt(maxId), 5)
            .join(idSeparatorChar)
        : null,
  );
}

void main() {
  late AppDatabase database;

  final faker = Faker();

  setUp(() {
    final inMemory = DatabaseConnection(NativeDatabase.memory());
    database = AppDatabase.forTesting(inMemory);
  });

  tearDown(() => database.close());

  test(
    'Starts empty',
    () async {
      expect(await database.allQuotes, isEmpty);
      expect(await database.allTags, isEmpty);
    },
  );

  group('Quotes', () {
    late Quote sampleQuote; // Id will be added automatically
    setUp(() {
      sampleQuote = _generateRandomQuote();
    });

    test('Quote is being added', () async {
      expect(
        sampleQuote.id,
        isNull,
        reason: 'Before add, the quote can have a null id.',
      );

      await database.addQuote(sampleQuote);

      expect(await database.allQuotes, hasLength(1));
    });

    test('Quote after add have non-null id', () async {
      await database.addQuote(sampleQuote);

      expect(await database.allQuotes, hasLength(1));

      final addedQuote = (await database.allQuotes).single;

      expect(addedQuote.id, isNotNull);
    });

    test('Add two quotes will have different ids', () async {
      final secondQuote = sampleQuote.copyWith(
        content: faker.lorem.sentence(),
        author: faker.person.name(),
      );

      await database.addQuote(sampleQuote);
      await database.addQuote(secondQuote);

      final [first, second] = await database.allQuotes;

      expect(first.id, isNotNull);
      expect(second.id, isNotNull);

      expect(first.id, isNot(second.id));
    });

    test(
      'Add quote with same id will replace',
      () async {
        await database.addQuote(sampleQuote);

        final addedQuote = (await database.allQuotes).single;

        final addedQuoteId = addedQuote.id;

        expect(addedQuoteId, isNotNull);

        final anotherQuote =
            _generateRandomQuote().copyWith(id: Value(addedQuoteId));

        expect(anotherQuote.id, equals(addedQuoteId));

        expect(anotherQuote, isNot(addedQuote));

        await database.addQuote(anotherQuote);

        expect(await database.allQuotes, hasLength(1));

        final newAddedQuote = (await database.allQuotes).single;

        expect((await database.allQuotes).single, isNot(addedQuote));

        expect((await database.allQuotes).single, equals(newAddedQuote));
      },
    );
  });
}
