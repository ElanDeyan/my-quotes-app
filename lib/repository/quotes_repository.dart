import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

abstract interface class QuotesRepository {
  Future<List<Quote>> get allQuotes;

  Future<Quote?> get randomQuote;

  Future<Quote?> getQuoteById(int id);

  Future<List<Quote>> getQuotesWithTagId(int tagId);

  Future<int> createQuote(Quote quote);

  Future<bool> updateQuote(Quote quote);

  Future<int> deleteQuote(int id);

  Future<void> clearAllQuotes();

  Future<void> restoreQuotes(List<Quote> quotes);

  Stream<List<Quote>> get favorites;
}
