import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

Future<bool?> showDeleteQuoteDialog(BuildContext context, Quote quote) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.appLocalizations.areYouSure),
      icon: const Icon(Icons.delete_forever),
      content: Text(context.appLocalizations.irreversibleAction),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.appLocalizations.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
              (states) => Theme.of(context).colorScheme.errorContainer,
            ),
          ),
          child: Text(
            context.appLocalizations.delete,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ),
      ],
    ),
  );
}
