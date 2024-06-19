import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/actions/tags/show_update_tag_dialog.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

void updateTag(BuildContext context, Tag tag) {
  final database = Provider.of<DatabaseProvider>(context, listen: false);
  final result = showUpdateTagDialog(context, tag);
  result.then(
    (value) {
      if (value.isNotNullOrBlank) {
        database.updateTag(tag.copyWith(name: value));
        FToast().init(context).showToast(
              child: Chip(
                label: const Text('Successfully updated!'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            );
      }
    },
  );
}
