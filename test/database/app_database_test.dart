import 'dart:math';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

const _minRetryAttempts = 3;

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

  test('Starts empty', () async {
    expect(await database.allQuotes, isEmpty);
    expect(await database.allTags, isEmpty);
  });

  group('Quotes:', () {
    late Quote sampleQuote; // Id will be added automatically
    setUp(() {
      sampleQuote = _generateRandomQuote();
    });

    group('Add quote:', () {
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

      test('Add quote with same id will replace', () async {
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
      });

      test('Auto increment id doesnt make conflict', () async {
        sampleQuote = sampleQuote.copyWith(id: const Value(3));

        await database.addQuote(sampleQuote);

        final addedQuoteWithId3 = (await database.allQuotes).single;

        expect(addedQuoteWithId3.id, equals(3));

        final quotesToAdd = [
          for (var i = 0; i < 3; i++) _generateRandomQuote(),
        ];

        for (final quote in quotesToAdd) {
          await database.addQuote(quote);
        }

        expect(
          await database.allQuotes,
          hasLength(quotesToAdd.length + 1),
          reason:
              'Even the id 3 already existing, the auto increment will take the next available id',
        );

        expect(await database.getQuoteById(3), addedQuoteWithId3);

        expect(
          (await database.allQuotes).last.id,
          equals(addedQuoteWithId3.id! + quotesToAdd.length),
          reason:
              'The database will take the next available id from the higher one. '
              'In this case, he wont take the id 1, even being available, he will start to add from 4, the next one of the quote with id 3.',
        );
      });
    });

    group('Get Quote:', () {
      test('Getting quote by id', () async {
        await database.addQuote(sampleQuote);

        final addedQuote = (await database.allQuotes).single;
        final addedQuoteId = addedQuote.id!;

        final quoteById = await database.getQuoteById(addedQuoteId);

        expect(quoteById, isNotNull);
        expect(quoteById, isA<Quote>());

        expect(quoteById, equals(addedQuote));
      });

      test(
        'Getting null for not found id',
        () async {
          await database.addQuote(sampleQuote);

          final addedId = (await database.allQuotes).single.id!;

          final randomId =
              Random.secure().nextInt(50) + 2; // to start from 2 to 50

          expect(addedId, isNot(randomId));

          final maybeQuote = await database.getQuoteById(randomId);

          expect(maybeQuote, isNull);
        },
        retry: _minRetryAttempts,
      );

      test('Random quote: null if empty', () async {
        expect(await database.allQuotes, isEmpty);

        final maybeQuote = await database.randomQuote;

        expect(maybeQuote, isNull);
      });
    });

    group('Updating quote', () {
      test(
        'Simple case',
        () async {
          await database.addQuote(sampleQuote);

          final oldQuote = (await database.allQuotes).single;

          final updatedQuote =
              oldQuote.copyWith(content: faker.lorem.sentence());

          expect(oldQuote.content, isNot(updatedQuote.content));

          await database.updateQuote(updatedQuote);

          expect(await database.allQuotes, hasLength(1));

          expect((await database.allQuotes).single, isNot(oldQuote));
        },
        retry: _minRetryAttempts,
      );

      test('Updating in non-existent id doesnt add', () async {
        await database.addQuote(sampleQuote);
        await database.addQuote(_generateRandomQuote());

        final quotesQuantity = (await database.allQuotes).length;

        final nonExistentId = quotesQuantity + 1;

        await database.updateQuote(
          _generateRandomQuote().copyWith(id: Value(nonExistentId)),
        );

        expect(await database.allQuotes, hasLength(quotesQuantity));
      });
    });

    group('Deleting', () {
      test('Basic deleting', () async {
        await database.addQuote(sampleQuote);
        expect(await database.allQuotes, hasLength(1));

        final addedQuote = (await database.allQuotes).single;

        await database.removeQuote(addedQuote.id!);

        expect(await database.allQuotes, isEmpty);

        expect(
          (await database.allQuotes).contains(addedQuote),
          isFalse,
        );
      });

      test('Delete non-existent id does nothing', () async {
        await database.addQuote(sampleQuote);

        final addedQuote = (await database.allQuotes).single;

        final addedId = addedQuote.id!;

        const nonExistentId = 2;

        expect(addedId, isNot(nonExistentId));

        await database.removeQuote(nonExistentId);

        expect(await database.allQuotes, hasLength(1));

        expect(await database.allQuotes, containsOnce(addedQuote));
      });
    });

    group('Clear all quotes', () {
      test('Basic case', () async {
        expect(await database.allQuotes, isEmpty);

        final quotesToAdd = [
          for (var i = 0; i < 10; i++) _generateRandomQuote(),
        ];

        for (final quote in quotesToAdd) {
          await database.addQuote(quote);
        }

        expect(await database.allQuotes, hasLength(quotesToAdd.length));

        await database.clearAllQuotes();

        expect(await database.allQuotes, isEmpty);
      });
    });
  });

  group('Integration (Quotes and Tags)', () {
    late Quote sampleQuote;
    late Tag sampleTag;

    setUp(() {
      sampleQuote = _generateRandomQuote();
      sampleTag = Tag(name: faker.lorem.word().toLowerCase());
    });

    test('Quote with some tag', () async {
      await database.createTag(sampleTag);

      final tagId = (await database.allTags).single.id;

      await database.addQuote(sampleQuote.copyWith(tags: Value('$tagId')));

      final addedQuote = (await database.allQuotes).single;

      final quotesWithTagId = await database.getQuotesWithTagId(tagId!);

      expect(quotesWithTagId, isNotEmpty);

      expect(quotesWithTagId, containsOnce(addedQuote));
    });
  });
}
