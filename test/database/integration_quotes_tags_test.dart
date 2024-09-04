import 'package:basics/basics.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/quote_extension.dart';

import '../fixtures/generate_random_quote.dart';
import '../fixtures/generate_random_tag.dart';
import '../fixtures/list_extension.dart';

void main() {
  late AppDatabase appDatabase;

  setUp(() {
    final inMemory = DatabaseConnection(NativeDatabase.memory());
    appDatabase = AppDatabase.forTesting(inMemory);
  });

  tearDown(() => appDatabase.close());

  test('Get Quotes with tag', () async {
    final sampleTagName = faker.lorem.word().toLowerCase();
    await appDatabase.createTag(sampleTagName);
    final addedTag = (await appDatabase.allTags).single;

    const numberOfQuotes = 5;

    for (var i = 0; i < numberOfQuotes; i++) {
      final quoteToAdd =
          generateRandomQuote().copyWith(tags: Value(addedTag.id.toString()));

      await appDatabase.createQuote(
        quoteToAdd,
      );
    }

    final quotesWithTag = await appDatabase.getQuotesWithTagId(addedTag.id!);

    expect(quotesWithTag, hasLength(numberOfQuotes));
  });

  test('Quotes with tag stream', () async {
    final sampleTagName = faker.lorem.word().toLowerCase();
    await appDatabase.createTag(sampleTagName);
    final addedTag = (await appDatabase.allTags).single;

    const numberOfQuotes = 5;

    for (var i = 0; i < numberOfQuotes; i++) {
      final quoteToAdd =
          generateRandomQuote().copyWith(tags: Value(addedTag.id.toString()));

      await appDatabase.createQuote(
        quoteToAdd,
      );
    }

    await expectLater(
      appDatabase.getQuotesWithTagIdStream(addedTag.id!),
      emits(await appDatabase.allQuotes),
    );
  });

  test('When deleting tag, quotes with this tag will loose it', () async {
    const tagName1 = 'tag1';
    const tagName2 = 'tag2';

    await appDatabase.createTag(tagName1);
    await appDatabase.createTag(tagName2);

    final [tag1, tag2] = await appDatabase.allTags;

    await appDatabase.createQuote(
      generateRandomQuote().copyWith(tags: Value('${tag1.id},${tag2.id}')),
    );

    final [quoteBeforeTagDelete] = await appDatabase.allQuotes;

    expect(quoteBeforeTagDelete.tagsId, hasLength(2));

    await appDatabase.deleteTag(tag1.id!);

    final [quoteAfterTagDelete] = await appDatabase.allQuotes;

    expect(quoteAfterTagDelete.tagsId, hasLength(1));
    expect(quoteAfterTagDelete.tagsId.contains(tag1.id), isFalse);
  });

  test('When clearing tags, all quotes loose their tags', () async {
    const numberOfTagsToAdd = 10;
    for (var i = 0; i < numberOfTagsToAdd; i++) {
      await appDatabase.createTag(faker.lorem.word().toLowerCase());
    }

    final tags = await appDatabase.allTags;

    const numberOfQuotesToAdd = 10;
    for (var i = 0; i < numberOfQuotesToAdd; i++) {
      await appDatabase.createQuote(
        generateRandomQuote().copyWith(
          tags: Value((tags..shuffle()).take(3).join(idSeparatorChar)),
        ),
      );
    }

    await appDatabase.clearAllTags();

    expect(await appDatabase.allTags, isEmpty);

    for (final quote in await appDatabase.allQuotes) {
      expect(quote.tags.isNullOrBlank, isTrue);
      expect(quote.tagsId, isEmpty);
    }
  });

  group('Restoring > ', () {
    late List<Tag> sampleTags;
    late List<Quote> sampleQuotesWithSampleTags;

    setUp(() {
      sampleTags = [
        for (var i = 0; i < 5; i++)
          generateRandomTag().copyWith(id: Value(i + 1)),
      ];

      sampleQuotesWithSampleTags = [
        for (var i = 0; i < 5; i++)
          generateRandomQuote().copyWith(
            id: Value(i + 1),
            tags: Value(
              (sampleTags..shuffle())
                  .take(3)
                  .map((tag) => tag.id)
                  .join(idSeparatorChar),
            ),
          ),
      ];
    });
    test('Database cleared, only recovering data', () async {
      expect(await appDatabase.allQuotes, isEmpty);
      expect(await appDatabase.allTags, isEmpty);

      await appDatabase.restoreData(sampleTags, sampleQuotesWithSampleTags);

      expect(
        await appDatabase.allQuotes,
        containsAll(sampleQuotesWithSampleTags),
      );
      expect(await appDatabase.allTags, containsAll(sampleTags));
    });

    test('Already filled db: clear all and replaces for the new one', () async {
      // Filling db to replace with [sampleTags] and [sampleQuotesWithSampleTags]
      for (var i = 0; i < 10; i++) {
        await appDatabase.createTag(generateRandomTag().name);
      }

      final tagsBeforeRestore = await appDatabase.allTags;

      for (var i = 0; i < 10; i++) {
        await appDatabase.createQuote(
          generateRandomQuote().copyWith(
            tags: Value(
              tagsBeforeRestore.toShuffledView
                  .take(3)
                  .map((tag) => tag.id)
                  .join(idSeparatorChar),
            ),
          ),
        );
      }

      final quotesBeforeRestore = await appDatabase.allQuotes;

      await appDatabase.restoreData(sampleTags, sampleQuotesWithSampleTags);

      expect(
        await appDatabase.allQuotes,
        isNot(quotesBeforeRestore),
      );
      expect(
        await appDatabase.allTags,
        isNot(tagsBeforeRestore),
      );

      expect(
        await appDatabase.allTags,
        containsAll(sampleTags),
      );
      expect(
        await appDatabase.allQuotes,
        containsAll(sampleQuotesWithSampleTags),
      );
    });
  });
}
