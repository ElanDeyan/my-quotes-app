import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

enum QuotesListViewFiltering {
  favorites,
  none;

  List<Quote> filter(List<Quote> quotes) => switch (this) {
        QuotesListViewFiltering.favorites =>
          quotes.where((quote) => quote.isFavorite).toList(),
        QuotesListViewFiltering.none => quotes,
      };
}
