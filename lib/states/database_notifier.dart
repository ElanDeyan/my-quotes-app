import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/repository/quotes_repository.dart';

final class DatabaseNotifier extends ChangeNotifier
    implements QuotesRepository {
  DatabaseNotifier({
    required QuotesRepository quotesRepository,
  }) : _quotesRepository = quotesRepository;

  final QuotesRepository _quotesRepository;

  @override
  Future<List<Quote>> get allQuotes => _quotesRepository.allQuotes;

  @override
  Future<int> addQuote(Quote quote) {
    final newId = _quotesRepository.addQuote(quote);
    notifyListeners();
    return newId;
  }

  @override
  Stream<List<Quote>> get favorites => _quotesRepository.favorites;

  @override
  Future<Quote?> getQuoteById(int id) async {
    print(await allQuotes);
    final quoteOrNull = _quotesRepository.getQuoteById(id);
    
    return quoteOrNull;
  }

  @override
  Future<Quote?> get randomQuote => _quotesRepository.randomQuote;

  @override
  Future<int> removeQuote(int id) {
    final oldId = _quotesRepository.removeQuote(id);
    notifyListeners();
    return oldId;
  }

  @override
  Future<bool> updateQuote(Quote quote) {
    final didUpdate = _quotesRepository.updateQuote(quote);
    notifyListeners();
    return didUpdate;
  }
}
