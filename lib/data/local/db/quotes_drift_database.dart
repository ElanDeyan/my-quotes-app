import 'package:drift/drift.dart';
import 'package:my_quotes/data/local/db/connection/connection.dart' as impl;
import 'package:my_quotes/data/tables/quote_table.dart';
import 'package:my_quotes/data/tables/tag_table.dart';
import 'package:my_quotes/helpers/iterable_extension.dart';
import 'package:my_quotes/repository/app_repository.dart';

part 'quotes_drift_database.g.dart';

@DriftDatabase(tables: [QuoteTable, TagTable])
final class AppDatabase extends _$AppDatabase implements AppRepository {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async => await m.createAll(),
      onUpgrade: (m, from, to) async {
        if (from < 3) {
          await m.deleteTable('tag_table');
          await m.createTable(tagTable);
        }
      },
    );
  }

  @override
  Future<int> addQuote(Quote quote) async {
    return into(quoteTable).insert(
      QuoteTableCompanion.insert(
        content: quote.content,
        author: quote.author,
        createdAt: Value(DateTime.now()),
        isFavorite: Value(quote.isFavorite),
        source: Value(quote.source),
        sourceUri: Value(quote.sourceUri),
        tags: Value(quote.tags),
      ),
      mode: InsertMode.insertOrReplace,
      onConflict: DoNothing(),
    );
  }

  @override
  Future<List<Quote>> get allQuotes async => select(quoteTable).get();

  @override
  Stream<List<Quote>> get favorites =>
      (select(quoteTable)..where((row) => row.isFavorite.equals(true))).watch();

  @override
  Future<Quote?> getQuoteById(int id) {
    return (select(quoteTable)..where((row) => row.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<Quote?> get randomQuote async {
    final quotes = await allQuotes;

    return quotes.singleSampleOrNull;
  }

  @override
  Future<int> removeQuote(int id) {
    return delete(quoteTable).delete(QuoteTableCompanion(id: Value(id)));
  }

  @override
  Future<bool> updateQuote(Quote quote) {
    return update(quoteTable).replace(
      QuoteTableCompanion.insert(
        id: Value(quote.id),
        content: quote.content,
        author: quote.author,
        createdAt: Value(quote.createdAt),
        isFavorite: Value(quote.isFavorite),
        source: Value(quote.source),
        sourceUri: Value(quote.sourceUri),
        tags: Value(quote.tags),
      ),
    );
  }

  @override
  Future<List<Tag>> get allTags async => select(tagTable).get();

  @override
  Future<int> createTag(Tag tag) async {
    return into(tagTable).insert(
      TagTableCompanion.insert(name: tag.name),
      mode: InsertMode.insertOrReplace,
      onConflict: DoNothing(),
    );
  }

  @override
  Future<Tag?> getTagById(int id) {
    return (select(tagTable)..where((row) => row.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<List<Tag>> getTagsByIds(Iterable<int> ids) {
    return (select(tagTable)..where((row) => row.id.isIn(ids))).get();
  }

  @override
  Future<int> removeTag(int id) {
    return delete(tagTable).delete(TagTableCompanion(id: Value(id)));
  }

  @override
  Future<bool> updateTag(Tag tag) {
    return update(tagTable).replace(
      TagTableCompanion.insert(
        id: Value(tag.id),
        name: tag.name,
      ),
    );
  }
}
