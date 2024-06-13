import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/screens/update_quote_screen.dart';

Future<void> showUpdateQuoteDialog(BuildContext context, Quote quote) {
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog.fullscreen(
      child: UpdateQuoteScreen(quoteId: quote.id!),
    ),
  );
}
