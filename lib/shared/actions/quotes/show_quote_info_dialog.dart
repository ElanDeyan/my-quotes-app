import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/quote_single/quote_screen_dialog_body.dart';

Future<void> showQuoteInfoDialog(BuildContext context, Quote quote) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.info),
      scrollable: true,
      title: Text(context.appLocalizations.quoteInfo),
      content: QuoteScreenDialogBody(quoteId: quote.id!),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
            context.pushReplacementNamed(
              updateQuoteNavigationKey,
              pathParameters: {'id': quote.id.toString()},
            );
          },
          child: Text(context.appLocalizations.edit),
        ),
        OutlinedButton(
          onPressed: () => context.pop(),
          child: Text(context.appLocalizations.ok),
        ),
      ],
    ),
  );
}
