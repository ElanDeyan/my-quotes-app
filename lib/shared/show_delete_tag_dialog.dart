import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

Future<bool?> showDeleteTagDialog(BuildContext context, Tag tag) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.warning),
      title: Text('Delete "${tag.name}" tag?'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("This can't be undone."),
          Text('All quotes with this tag will only loose this tag.'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => Theme.of(context).colorScheme.errorContainer,
            ),
          ),
          child: Text(
            'Delete',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ),
      ],
    ),
  );
}
