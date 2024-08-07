import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/actions/tags/show_delete_tag_dialog.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

void deleteTag(BuildContext context, Tag tag) {
  final result = showDeleteTagDialog(context, tag);

  result.then(
    (value) {
      if (value == true) {
        if (context.mounted) {
          final database =
              Provider.of<DatabaseProvider>(context, listen: false);
          database.deleteTag(tag.id!);
          showToast(
            context,
            child: PillChip(label: Text(AppLocalizations.of(context)!.deleted)),
          );
        }
      }
    },
  );
}
