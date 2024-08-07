import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool?> showWantsToImportDialog(BuildContext context) => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context, false),
            label: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton.icon(
            onPressed: () => Navigator.pop(context, true),
            label: Text(AppLocalizations.of(context)!.restoreData),
          ),
        ],
        icon: const Icon(Icons.backup_outlined),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.restoreQuestion),
            Text(
              AppLocalizations.of(context)!.restoreAdvice,
            ),
          ],
        ),
      ),
    );
