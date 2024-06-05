import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/show_delete_quote_dialog.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

Future<void> deleteQuote(BuildContext context, Quote quote) async {
  final result = showDeleteQuoteDialog(context, quote);

  result.then((value) {
    if (value == true) {
      _deleteQuote(context, quote);
      FToast().init(context).showToast(child: const Text('Deleted'));
    }
  });
}

void _deleteQuote(BuildContext context, Quote quote) {
  final database = Provider.of<DatabaseProvider>(context, listen: false);
  database.removeQuote(quote.id!);
}
