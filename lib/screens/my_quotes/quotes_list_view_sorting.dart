import 'package:basics/list_basics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

enum QuotesListViewSorting {
  createdAtAsc,
  createdAtDesc;

  List<Quote> sort(List<Quote> quotes) => switch (this) {
        QuotesListViewSorting.createdAtAsc => quotes.sortedCopyBy(
            (quote) => quote.createdAt!,
          ),
        QuotesListViewSorting.createdAtDesc =>
          quotes.sortedCopyBy((quote) => quote.createdAt!).reversed.toList(),
      };

  String localizedName(AppLocalizations appLocalizations) => switch (this) {
        QuotesListViewSorting.createdAtAsc =>
          appLocalizations.quotesListViewSortingCreatedAtAsc,
        QuotesListViewSorting.createdAtDesc =>
          appLocalizations.quotesListViewSortingCreatedAtDesc,
      };
}
