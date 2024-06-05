import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

Future<bool?> showDeleteQuoteDialog(BuildContext context, Quote quote) {
  return showDialog<bool?>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Are you sure?'),
      icon: const Icon(Icons.delete_forever),
      content: const Text('This action cannot be undone'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
