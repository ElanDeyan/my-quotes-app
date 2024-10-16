import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

abstract interface class QuotesRepository {
  Future<List<Quote>> get allQuotes;

  Future<Quote?> get randomQuote;

  Stream<List<Quote>> get allQuotesStream;

  Future<Quote?> getQuoteById(int id);

  Stream<Quote?> getQuoteByIdStream(int id);

  Future<List<Quote>> getQuotesWithTagId(int tagId);

  Stream<List<Quote>> getQuotesWithTagIdStream(int id);

  Future<Quote> createQuote(Quote quote);

  Future<bool> updateQuote(Quote quote);

  Future<int> deleteQuote(int id);

  Future<void> clearAllQuotes();

  Future<void> restoreQuotes(List<Quote> quotes);

  Stream<List<Quote>> get favorites;
}
