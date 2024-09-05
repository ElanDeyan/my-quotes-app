import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/nullable_extension.dart';
import 'package:my_quotes/repository/interfaces/app_repository.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/actions/tags/show_create_tag_dialog.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';

void createTag(BuildContext context) {
  final result = showCreateTagDialog(context);

  if (result.isNotNull) {
    result!.then((value) {
      if (value.isNotNullOrBlank) {
        if (context.mounted) {
          serviceLocator<AppRepository>().createTag(value!).then(
                (_) => context.mounted
                    ? showToast(
                        context,
                        child: PillChip(
                          label: Text(context.appLocalizations.created),
                        ),
                      )
                    : null,
              );
        }
      }
    });
  }
}
