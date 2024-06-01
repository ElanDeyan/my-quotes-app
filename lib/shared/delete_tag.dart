import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/show_delete_tag_dialog.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

void deleteTag(BuildContext context, Tag tag) {
  final result = showDeleteTagDialog(context, tag);

  result.then(
    (value) {
      if (value == true) {
        final database = Provider.of<DatabaseProvider>(context, listen: false);
        database.deleteTag(tag.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully deleted!')),
        );
      }
    },
  );
}
