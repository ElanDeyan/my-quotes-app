import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

Future<Tag?> showTagSearch(BuildContext context, SearchDelegate<Tag> delegate) {
  return showSearch(context: context, delegate: delegate);
}
