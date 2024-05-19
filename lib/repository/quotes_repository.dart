import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

abstract interface class QuotesRepository {
  Future<List<Quote>> get allQuotes;

  Future<Quote?> get randomQuote;

  Future<Quote?> getQuoteById(int id);

  Future<int> addQuote(Quote quote);

  Future<bool> updateQuote(Quote quote);

  Future<int> removeQuote(int id);

  Stream<List<Quote>> get favorites;
}
