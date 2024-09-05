import 'package:basics/basics.dart';
import 'package:drift/drift.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/connection/connection.dart' as impl;
import 'package:my_quotes/data/local/db/daos/quotes_dao.dart';
import 'package:my_quotes/data/local/db/daos/tags_dao.dart';
import 'package:my_quotes/data/tables/quote_table.dart';
import 'package:my_quotes/data/tables/tag_table.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/repository/interfaces/app_repository.dart';

part 'quotes_drift_database.g.dart';

@DriftDatabase(tables: [QuoteTable, TagTable], daos: [QuotesDao, TagsDao])
final class AppDatabase extends _$AppDatabase implements AppRepository {
  AppDatabase() : super(impl.connect());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async => await m.createAll(),
      onUpgrade: (m, from, to) async {
        if (from < 3) {
          await m.deleteTable('tag_table');
          await m.createTable(tagTable);
        } else if (from < 4) {
          await m.deleteTable('quote_table');
          await m.createTable(quoteTable);

          await m.deleteTable('tag_table');
          await m.createTable(tagTable);
        }
      },
    );
  }

  @override
  Future<List<Quote>> get allQuotes async => quotesDao.allQuotes;

  @override
  Stream<List<Quote>> get favorites =>
      (select(quoteTable)..where((row) => row.isFavorite.equals(true))).watch();

  @override
  Future<Quote> createQuote(Quote quote) async {
    return into(quoteTable).insertReturning(
      quote.toCompanion(true),
      mode: InsertMode.insertOrReplace,
    );
  }

  @override
  Future<Quote?> getQuoteById(int id) => quotesDao.getQuoteById(id);

  @override
  Future<List<Quote>> getQuotesWithTagId(int tagId) async =>
      quotesDao.getQuotesWithTagId(tagId);

  @override
  Future<Quote?> get randomQuote => quotesDao.randomQuote;

  @override
  Stream<List<Quote>> get allQuotesStream => quotesDao.allQuotesStream;

  @override
  Future<bool> updateQuote(Quote quote) {
    return update(quoteTable).replace(
      quote.toCompanion(true),
    );
  }

  @override
  Future<int> deleteQuote(int id) {
    return delete(quoteTable).delete(QuoteTableCompanion(id: Value(id)));
  }

  @override
  Future<void> clearAllQuotes() async {
    delete(quoteTable).go();
  }

  @override
  Future<void> restoreQuotes(List<Quote> quotes) async {
    batch((batch) {
      batch
        ..deleteAll(quoteTable)
        ..insertAll(
          quoteTable,
          quotes.map((quote) => quote.toCompanion(true)),
        );
    });
  }

  @override
  Future<List<Tag>> get allTags => tagsDao.allTags;

  @override
  Stream<List<Tag>> get allTagsStream => tagsDao.allTagsStream;

  @override
  Future<Tag> createTag(String tagName) async {
    return into(tagTable).insertReturning(
      TagTableCompanion.insert(name: tagName),
      mode: InsertMode.insertOrReplace,
    );
  }

  @override
  Future<Tag?> getTagById(int id) => tagsDao.getTagById(id);

  @override
  Future<List<Tag>> getTagsByIds(Iterable<int> ids) =>
      tagsDao.getTagsByIds(ids);

  @override
  Future<bool> updateTag(Tag tag) {
    return update(tagTable).replace(
      tag.toCompanion(true),
    );
  }

  @override
  Future<int> deleteTag(int id) async {
    await delete(tagTable).delete(TagTableCompanion(id: Value(id)));

    final quotesWithThisTag =
        (await allQuotes).where((quote) => quote.tagsId.contains(id));

    for (final quote in quotesWithThisTag) {
      if (quote.tags.isNotNullOrBlank) {
        final newIdsString = quote.tags!.split(idSeparatorChar)..remove('$id');

        updateQuote(
          quote.copyWith(tags: Value(newIdsString.join(idSeparatorChar))),
        );
      }
    }

    return id;
  }

  @override
  Future<void> clearAllTags() async {
    await delete(tagTable).go();

    for (final quote in await allQuotes) {
      await update(quoteTable)
          .replace(quote.toCompanion(true).copyWith(tags: const Value(null)));
    }
  }

  @override
  Future<void> restoreTags(List<Tag> tags) async {
    batch((batch) {
      batch
        ..deleteAll(tagTable)
        ..insertAll(
          tagTable,
          tags.map((tag) => tag.toCompanion(true)),
        );
    });
  }

  @override
  Future<void> restoreData(List<Tag> tags, List<Quote> quotes) async {
    await restoreTags(tags);
    await restoreQuotes(quotes);
  }

  @override
  Stream<Quote?> getQuoteByIdStream(int id) => quotesDao.getQuoteByIdStream(id);

  @override
  Stream<List<Quote>> getQuotesWithTagIdStream(int id) =>
      quotesDao.getQuotesWithTagIdStream(id);
}
