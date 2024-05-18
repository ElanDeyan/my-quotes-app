import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

abstract interface class QuotesRepository {
  Future<List<Quote>> get allQuotes;

  Future<Quote> get randomQuote;

  Stream<Quote?> getQuoteById(int id);

  Future<int> addQuote(Quote quote);

  Future<int> updateQuote(int id);

  Future<int> removeQuote(int id);

  Future<List<Quote>> get favorites;
}
