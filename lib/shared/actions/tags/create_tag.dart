import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/nullable_extension.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/actions/tags/show_create_tag_dialog.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

void createTag(BuildContext context) {
  final result = showCreateTagDialog(context);

  if (result.isNotNull) {
    result!.then((value) {
      if (value.isNotNullOrBlank) {
        if (context.mounted) {
          final database =
              Provider.of<DatabaseProvider>(context, listen: false);
          database.createTag(value!);
          showToast(
            context,
            child: PillChip(label: Text(context.appLocalizations.created)),
          );
        }
      }
    });
  }
}
