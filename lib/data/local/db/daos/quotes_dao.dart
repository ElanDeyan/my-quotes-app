import 'package:drift/drift.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/data/tables/quote_table.dart';

part 'quotes_dao.g.dart';

@DriftAccessor(tables: [QuoteTable])
class QuotesDao extends DatabaseAccessor<AppDatabase> with _$QuotesDaoMixin {
  QuotesDao(super.attachedDatabase);

  Future<List<Quote>> get allQuotes => select(quoteTable).get();
  
}
