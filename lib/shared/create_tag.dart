import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/nullable_extension.dart';
import 'package:my_quotes/shared/show_create_tag_dialog.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

void createTag(BuildContext context) {
  final result = showCreateTagDialog(context);

  if (result.isNotNull) {
    result!.then((value) {
      if (value.isNotNullOrBlank) {
        final database = Provider.of<DatabaseProvider>(context, listen: false);
        database.createTag(Tag(name: value!));
        FToast().init(context).showToast(
              child: Chip(
                label: const Text('Created!'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            );
      }
    });
  }
}
