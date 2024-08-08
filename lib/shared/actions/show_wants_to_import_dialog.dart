import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

Future<bool?> showWantsToImportDialog(BuildContext context) => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context, false),
            label: Text(context.appLocalizations.cancel),
          ),
          TextButton.icon(
            onPressed: () => Navigator.pop(context, true),
            label: Text(context.appLocalizations.restoreData),
          ),
        ],
        icon: const Icon(Icons.backup_outlined),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.appLocalizations.restoreQuestion),
            Text(
              context.appLocalizations.restoreAdvice,
            ),
          ],
        ),
      ),
    );
