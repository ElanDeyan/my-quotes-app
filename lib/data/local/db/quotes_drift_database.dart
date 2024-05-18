import 'package:drift/drift.dart';
import 'package:my_quotes/data/local/db/connection/connection.dart' as impl;
import 'package:my_quotes/data/tables/quote_table.dart';
import 'package:my_quotes/data/tables/tag_table.dart';
import 'package:my_quotes/repository/quotes_repository.dart';

part 'quotes_drift_database.g.dart';

@DriftDatabase(tables: [QuoteTable, TagTable])
final class AppDatabase extends _$AppDatabase implements QuotesRepository {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 1;

  @override
  Future<int> addQuote(Quote quote) async {
    return into(quoteTable).insert(quote, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<List<Quote>> get allQuotes async => select(quoteTable).get();

  @override
  Future<List<Quote>> get favorites async =>
      (await allQuotes).where((quote) => quote.isFavorite).toList();

  @override
  Stream<Quote> getQuoteById(int id) {
    return (select(quoteTable)..where((row) => row.id.equals(id)))
        .watchSingle();
  }

  @override
  // TODO: implement randomQuote
  Future<Quote> get randomQuote => throw UnimplementedError();

  @override
  Future<int> removeQuote(int id) {
    // TODO: implement removeQuote
    throw UnimplementedError();
  }

  @override
  Future<int> updateQuote(int id) {
    // TODO: implement updateQuote
    throw UnimplementedError();
  }
}
