import 'package:basics/basics.dart';
import 'package:drift/drift.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/data/tables/quote_table.dart';
import 'package:my_quotes/helpers/quote_extension.dart';

part 'quotes_dao.g.dart';

@DriftAccessor(tables: [QuoteTable])
class QuotesDao extends DatabaseAccessor<AppDatabase> with _$QuotesDaoMixin {
  QuotesDao(super.attachedDatabase);

  Future<List<Quote>> get allQuotes => select(quoteTable).get();

  Stream<List<Quote>> get allQuotesStream => select(quoteTable).watch();

  Future<Quote?> getQuoteById(int id) {
    return (select(quoteTable)..where((row) => row.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Quote>> getQuotesWithTagId(int tagId) async {
    final quotes = await allQuotes;

    return quotes.where((quote) => quote.tagsId.contains(tagId)).toList();
  }

  Future<Quote?> get randomQuote async => (await allQuotes).getRandom();
}
