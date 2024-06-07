import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

Future<Quote?> showQuoteSearch(BuildContext context, SearchDelegate<Quote> delegate) {
  return showSearch(context: context, delegate: delegate);
}
