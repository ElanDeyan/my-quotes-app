import 'dart:math';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

import '../fixtures/generate_random_quote.dart';

const _minRetryAttempts = 3;

void main() {
  late AppDatabase appDatabase;

  final faker = Faker();

  setUp(() {
    final inMemory = DatabaseConnection(NativeDatabase.memory());
    appDatabase = AppDatabase.forTesting(inMemory);
  });

  tearDown(() => appDatabase.close());

  test('Starts empty', () async {
    await expectLater(appDatabase.allQuotes, completion(isEmpty));
    await expectLater(appDatabase.allTags, completion(isEmpty));
  });

  group('Quotes:', () {
    late Quote sampleQuote; // Id will be added automatically
    setUp(() {
      sampleQuote = generateRandomQuote();
    });

    group('Add quote:', () {
      test('Quote is being added', () async {
        expect(
          sampleQuote.id,
          isNull,
          reason: 'Before add, the quote can have a null id.',
        );

        await appDatabase.createQuote(sampleQuote);

        await expectLater(appDatabase.allQuotes, completion(hasLength(1)));
      });

      test('Quote after add have non-null id', () async {
        await appDatabase.createQuote(sampleQuote);

        await expectLater(appDatabase.allQuotes, completion(hasLength(1)));

        final addedQuote = (await appDatabase.allQuotes).single;

        expect(addedQuote.id, isNotNull);
      });

      test('Add two quotes will have different ids', () async {
        final secondQuote = sampleQuote.copyWith(
          content: faker.lorem.sentence(),
          author: faker.person.name(),
        );

        await appDatabase.createQuote(sampleQuote);
        await appDatabase.createQuote(secondQuote);

        final [first, second] = await appDatabase.allQuotes;

        expect(first.id, isNotNull);
        expect(second.id, isNotNull);

        expect(first.id, isNot(second.id));
      });

      test('Add quote with same id will replace', () async {
        await appDatabase.createQuote(sampleQuote);

        final addedQuote = (await appDatabase.allQuotes).single;

        final addedQuoteId = addedQuote.id;

        expect(addedQuoteId, isNotNull);

        final anotherQuote =
            generateRandomQuote().copyWith(id: Value(addedQuoteId));

        expect(anotherQuote.id, equals(addedQuoteId));

        expect(anotherQuote, isNot(addedQuote));

        await appDatabase.createQuote(anotherQuote);

        await expectLater(appDatabase.allQuotes, completion(hasLength(1)));

        final newAddedQuote = (await appDatabase.allQuotes).single;

        expect((await appDatabase.allQuotes).single, isNot(addedQuote));

        expect((await appDatabase.allQuotes).single, equals(newAddedQuote));
      });

      test('Auto increment id doesnt make conflict', () async {
        sampleQuote = sampleQuote.copyWith(id: const Value(3));

        await appDatabase.createQuote(sampleQuote);

        final addedQuoteWithId3 = (await appDatabase.allQuotes).single;

        expect(addedQuoteWithId3.id, equals(3));

        final quotesToAdd = [
          for (var i = 0; i < 3; i++) generateRandomQuote(),
        ];

        for (final quote in quotesToAdd) {
          await appDatabase.createQuote(quote);
        }

        await expectLater(
          appDatabase.allQuotes,
          completion(hasLength(quotesToAdd.length + 1)),
          reason:
              'Even the id 3 already existing, the auto increment will take the next available id',
        );

        await expectLater(
          appDatabase.getQuoteById(3),
          completion(addedQuoteWithId3),
        );

        expect(
          (await appDatabase.allQuotes).last.id,
          equals(addedQuoteWithId3.id! + quotesToAdd.length),
          reason:
              'The database will take the next available id from the higher one. '
              'In this case, he wont take the id 1, even being available, he will start to add from 4, the next one of the quote with id 3.',
        );
      });
    });

    group('Get Quote:', () {
      group('All quotes', () {
        late List<Quote> sampleQuotes;
        setUp(() {
          sampleQuotes = List.generate(5, (_) => generateRandomQuote());
        });
        test('(future)', () async {
          await expectLater(appDatabase.allQuotes, completion(isEmpty));

          for (final quote in sampleQuotes) {
            await appDatabase.createQuote(quote);
          }

          await expectLater(
            appDatabase.allQuotes,
            completion(hasLength(sampleQuotes.length)),
          );
        });

        test('(stream)', () async {
          await expectLater(appDatabase.allQuotesStream, emits(isEmpty));

          for (final quote in sampleQuotes) {
            await appDatabase.createQuote(quote);
          }

          await expectLater(
            appDatabase.allQuotesStream,
            emits(hasLength(sampleQuotes.length)),
          );
        });
      });

      group('Getting by id', () {
        test('(future)', () async {
          await appDatabase.createQuote(sampleQuote);

          final addedQuote = (await appDatabase.allQuotes).single;
          final addedQuoteId = addedQuote.id!;

          final quoteById = await appDatabase.getQuoteById(addedQuoteId);

          expect(quoteById, isNotNull);
          expect(quoteById, isA<Quote>());

          expect(quoteById, equals(addedQuote));
        });

        test('(stream)', () async {
          await appDatabase.createQuote(sampleQuote);
          final addedQuote = (await appDatabase.allQuotes).single;
          final addedQuoteId = addedQuote.id!;

          await expectLater(
            appDatabase.getQuoteByIdStream(addedQuoteId),
            emits(addedQuote),
          );
        });
      });

      test(
        'Getting null for not found id',
        () async {
          await appDatabase.createQuote(sampleQuote);

          final addedId = (await appDatabase.allQuotes).single.id!;

          final randomId =
              Random.secure().nextInt(50) + 2; // to start from 2 to 50

          expect(addedId, isNot(randomId));

          final maybeQuote = await appDatabase.getQuoteById(randomId);

          expect(maybeQuote, isNull);
        },
        retry: _minRetryAttempts,
      );

      test('Random quote: null if empty', () async {
        await expectLater(appDatabase.allQuotes, completion(isEmpty));

        await expectLater(appDatabase.randomQuote, completion(isNull));
      });
    });

    group('Updating quote', () {
      test(
        'Simple case',
        () async {
          await appDatabase.createQuote(sampleQuote);

          final oldQuote = (await appDatabase.allQuotes).single;

          final updatedQuote =
              oldQuote.copyWith(content: faker.lorem.sentence());

          expect(oldQuote.content, isNot(updatedQuote.content));

          await appDatabase.updateQuote(updatedQuote);

          await expectLater(appDatabase.allQuotes, completion(hasLength(1)));

          expect((await appDatabase.allQuotes).single, isNot(oldQuote));
        },
        retry: _minRetryAttempts,
      );

      test('Updating in non-existent id doesnt add', () async {
        await appDatabase.createQuote(sampleQuote);
        await appDatabase.createQuote(generateRandomQuote());

        final quotesQuantity = (await appDatabase.allQuotes).length;

        final nonExistentId = quotesQuantity + 1;

        await appDatabase.updateQuote(
          generateRandomQuote().copyWith(id: Value(nonExistentId)),
        );

        await expectLater(
          appDatabase.allQuotes,
          completion(hasLength(quotesQuantity)),
        );
      });
    });

    group('Deleting', () {
      test('Basic deleting', () async {
        await appDatabase.createQuote(sampleQuote);
        await expectLater(appDatabase.allQuotes, completion(hasLength(1)));

        final addedQuote = (await appDatabase.allQuotes).single;

        await appDatabase.deleteQuote(addedQuote.id!);

        await expectLater(appDatabase.allQuotes, completion(isEmpty));

        await expectLater(
          appDatabase.allQuotes,
          isNot(containsOnce(addedQuote)),
        );
      });

      test('Delete non-existent id does nothing', () async {
        await appDatabase.createQuote(sampleQuote);

        final addedQuote = (await appDatabase.allQuotes).single;

        final addedId = addedQuote.id!;

        const nonExistentId = 2;

        expect(addedId, isNot(nonExistentId));

        await appDatabase.deleteQuote(nonExistentId);

        await expectLater(appDatabase.allQuotes, completion(hasLength(1)));

        await expectLater(
          appDatabase.allQuotes,
          completion(containsOnce(addedQuote)),
        );
      });
    });

    group('Clear all quotes', () {
      test('Basic case', () async {
        await expectLater(appDatabase.allQuotes, completion(isEmpty));

        final quotesToAdd = [
          for (var i = 0; i < 10; i++) generateRandomQuote(),
        ];

        for (final quote in quotesToAdd) {
          await appDatabase.createQuote(quote);
        }

        await expectLater(
          appDatabase.allQuotes,
          completion(hasLength(quotesToAdd.length)),
        );

        await appDatabase.clearAllQuotes();

        await expectLater(appDatabase.allQuotes, completion(isEmpty));
      });
    });
  });

  group('Integration (Quotes and Tags)', () {
    late Quote sampleQuote;
    late Tag sampleTag;

    setUp(() {
      sampleQuote = generateRandomQuote();
      sampleTag = Tag(name: faker.lorem.word().toLowerCase());
    });

    group('Quote with some tag', () {
      test('(future)', () async {
        await appDatabase.createTag(sampleTag.name);

        final tagId = (await appDatabase.allTags).single.id;

        await appDatabase
            .createQuote(sampleQuote.copyWith(tags: Value('$tagId')));

        final addedQuote = (await appDatabase.allQuotes).single;

        await expectLater(
          appDatabase.getQuotesWithTagId(tagId!),
          completion(containsOnce(addedQuote)),
        );
      });

      test('(stream)', () async {
        await appDatabase.createTag(sampleTag.name);

        final tagId = (await appDatabase.allTags).single.id;

        await appDatabase
            .createQuote(sampleQuote.copyWith(tags: Value('$tagId')));

        final addedQuote = (await appDatabase.allQuotes).single;

        await expectLater(
          appDatabase.getQuotesWithTagIdStream(tagId!),
          emits(containsOnce(addedQuote)),
        );
      });
    });
  });
}
