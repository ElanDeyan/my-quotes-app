import 'dart:math' show Random;

import 'package:basics/basics.dart';
import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart' show NativeDatabase;
import 'package:faker/faker.dart' show faker;
import 'package:flutter_test/flutter_test.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart'
    show AppDatabase, Tag;

import '../fixtures/generate_random_tag.dart';

void main() {
  late AppDatabase appDatabase;
  late Tag sampleTag;

  setUp(() {
    final inMemory = DatabaseConnection(NativeDatabase.memory());
    appDatabase = AppDatabase.forTesting(inMemory);
    sampleTag = generateRandomTag();
  });

  tearDown(() => appDatabase.close());

  test('Starts empty', () async {
    expect(await appDatabase.allTags, isEmpty);
  });

  group('Create', () {
    test('Basic', () async {
      await appDatabase.createTag(generateRandomTag().name);
      expect(await appDatabase.allTags, isNotEmpty);

      final addedTag = (await appDatabase.allTags).single;

      expect(await appDatabase.allTags, containsOnce(addedTag));
    });

    test('Non-null id after add', () async {
      expect(
        sampleTag.id,
        isNull,
        reason:
            'Before add, it can have null id; will receive automatically when added.',
      );

      await appDatabase.createTag(sampleTag.name);

      expect((await appDatabase.allTags).single.id, isNotNull);
    });

    test(
      'When add two or more tags (with null id) they will have different ids',
      () async {
        final tagsToAdd = [for (var i = 0; i < 5; i++) generateRandomTag()];

        for (final tag in tagsToAdd) {
          await appDatabase.createTag(tag.name);
        }

        expect(await appDatabase.allTags, hasLength(tagsToAdd.length));

        final addedIds =
            (await appDatabase.allTags).map((tag) => tag.id).nonNulls;

        expect(
          addedIds,
          orderedEquals(
            tagsToAdd.indexed.map(
              (indexed) => indexed.$1 + 1,
            ),
          ), // because index starts in 0 and the table starts with 1
        );
      },
    );
  });

  group('Get', () {
    test('by id', () async {
      await appDatabase.createTag(sampleTag.name);

      expect(await appDatabase.allTags, hasLength(1));

      final addedTag = (await appDatabase.allTags).single;

      expect(await appDatabase.getTagById(addedTag.id!), equals(addedTag));
    });

    test('by id (null if doesnt have id)', () async {
      const hardCodedId = 3;
      await appDatabase.createTag(sampleTag.name);

      expect(await appDatabase.allTags, hasLength(1));

      final addedTag = (await appDatabase.allTags).single;

      expect(addedTag.id, isNot(hardCodedId));

      expect(await appDatabase.getTagById(hardCodedId), isNull);
    });

    test('Get tags by ids', () async {
      final tagsToAdd = [for (var i = 0; i < 5; i++) generateRandomTag()];

      for (final tag in tagsToAdd) {
        await appDatabase.createTag(tag.name);
      }

      final tagsIds = (await appDatabase.allTags).map((tag) => tag.id!).toList()
        ..shuffle();

      final sampleIds = tagsIds.take(2);

      final tagsWithSampleIds = await appDatabase.getTagsByIds(sampleIds);

      expect(tagsWithSampleIds, isNotEmpty);

      expect(await appDatabase.allTags, containsAll(tagsWithSampleIds));
    });

    test('Tags by ids (when non existent ids => empty list)', () async {
      final tagsToAdd = [for (var i = 0; i < 5; i++) generateRandomTag()];

      // ids from 1 to 5
      for (final tag in tagsToAdd) {
        await appDatabase.createTag(tag.name);
      }

      final randomInvalidIds = [
        for (var i = 0; i < 3; i++) Random().nextInt(50) + 6,
      ];

      final maybeTags = await appDatabase.getTagsByIds(randomInvalidIds);

      expect(maybeTags, isEmpty);
    });

    test('Tags by ids (mixing valid and not valid ids)', () async {
      final tagsToAdd = [
        for (final id in [1, 3, 5])
          generateRandomTag().copyWith(id: Value(id)),
      ];

      for (final tag in tagsToAdd) {
        await appDatabase.createTag(tag.name);
      }

      const oneToFiveInclusive = [1, 2, 3, 4, 5];
      final tagsByMixedIds = await appDatabase.getTagsByIds(oneToFiveInclusive);

      expect(tagsByMixedIds, hasLength(tagsToAdd.length));
    });
  });

  group('Update', () {
    test('Basic case', () async {
      await appDatabase.createTag(generateRandomTag(generateId: true).name);

      final addedTag = (await appDatabase.allTags).single;

      await appDatabase
          .updateTag(addedTag.copyWith(name: faker.lorem.word().toLowerCase()));

      expect(await appDatabase.allTags, hasLength(1));

      final updatedTag = (await appDatabase.allTags).single;

      expect(addedTag.id, equals(updatedTag.id));
      expect(addedTag, isNot(updatedTag));
    });

    test('Update non-existent id not adds', () async {
      await appDatabase.createTag(sampleTag.name);

      final firstTag = (await appDatabase.allTags).single;

      final randomNonExistentId = Random().nextInt(50) + 2;

      expect(randomNonExistentId, isNot(firstTag.id));

      final supposedTagToUpdate =
          generateRandomTag().copyWith(id: Value(randomNonExistentId));

      await appDatabase.updateTag(supposedTagToUpdate);

      expect(await appDatabase.allTags, hasLength(1));

      final uniqueTag = (await appDatabase.allTags).single;

      expect(uniqueTag, equals(firstTag));
    });
  });

  group('Delete', () {
    test('Basic', () async {
      await appDatabase.createTag(sampleTag.name);

      final addedTag = (await appDatabase.allTags).single;

      await appDatabase.deleteTag(addedTag.id!);

      expect(await appDatabase.allTags, isEmpty);
      expect(await appDatabase.getTagById(addedTag.id!), isNull);
    });

    test('Delete non-existent does nothing', () async {
      await appDatabase.createTag(sampleTag.name);

      final firstTag = (await appDatabase.allTags).single;

      final randomNonExistentId = Random().nextInt(50) + 2;

      expect(firstTag.id, isNot(randomNonExistentId));

      await appDatabase.deleteTag(randomNonExistentId);

      expect(await appDatabase.allTags, hasLength(1));
      expect(await appDatabase.allTags, containsOnce(firstTag));
    });

    test('Clear all tags', () async {
      const numberOftagsToAdd = 10;
      for (var i = 0; i < numberOftagsToAdd; i++) {
        await appDatabase.createTag(generateRandomTag(generateId: true).name);
      }

      expect(await appDatabase.allTags, hasLength(numberOftagsToAdd));

      final addedTags = await appDatabase.allTags;

      await appDatabase.clearAllTags();

      expect(await appDatabase.allTags, isEmpty);

      expect((await appDatabase.allTags).containsAll(addedTags), isFalse);
    });
  });
}
