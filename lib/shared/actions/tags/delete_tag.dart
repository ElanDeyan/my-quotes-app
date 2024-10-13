import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/actions/tags/show_delete_tag_dialog.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';

void deleteTag(BuildContext context, Tag tag) =>
    showDeleteTagDialog(context, tag).then(
      (value) {
        if (value ?? false) {
          serviceLocator<AppRepository>().deleteTag(tag.id!).then(
                (_) => context.mounted
                    ? showToast(
                        context,
                        child: PillChip(
                          label: Text(context.appLocalizations.deleted),
                        ),
                      )
                    : null,
              );
        }
      },
    );
