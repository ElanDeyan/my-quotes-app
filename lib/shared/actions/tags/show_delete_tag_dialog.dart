import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

Future<bool?> showDeleteTagDialog(BuildContext context, Tag tag) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.warning),
      title: Text(context.appLocalizations.deleteTag(tag.name)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.appLocalizations.irreversibleAction),
          Text(context.appLocalizations.deleteTagEffects),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.appLocalizations.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith(
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
