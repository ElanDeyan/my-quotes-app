import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

Future<bool?> showDeleteQuoteDialog(BuildContext context, Quote quote) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.areYouSure),
      icon: const Icon(Icons.delete_forever),
      content: Text(AppLocalizations.of(context)!.irreversibleAction),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
              (states) => Theme.of(context).colorScheme.errorContainer,
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.delete,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ),
      ],
    ),
  );
}
