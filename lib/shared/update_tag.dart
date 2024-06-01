import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/show_update_tag_dialog.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

void updateTag(BuildContext context, Tag tag) {
  final database = Provider.of<DatabaseProvider>(context, listen: false);
  final result = showUpdateTagDialog(context, tag);
  result.then(
    (value) {
      if (value.isNotNullOrBlank) {
        database.updateTag(tag.copyWith(name: value));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully updated!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong")),
        );
      }
    },
  );
}
