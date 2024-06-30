import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/screens/add_quote_from_file.dart';

Future<void> showAddQuoteFromFileDialog(
  BuildContext context,
  Quote quote,
  List<String> tags,
) {
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog.fullscreen(
      child: AddQuoteFromFileScreen(
        quote: quote,
        tags: tags,
      ),
    ),
  );
}
