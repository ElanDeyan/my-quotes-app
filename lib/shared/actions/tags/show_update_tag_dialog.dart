import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/widgets/tag_name_field.dart';

Future<String?> showUpdateTagDialog(BuildContext context, Tag tag) {
  final textEditingController =
      TextEditingController.fromValue(TextEditingValue(text: tag.name));
  final updateTagFormKey = GlobalKey<FormState>();
  return showDialog<String?>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.updateTag),
      content: Form(
        key: updateTagFormKey,
        autovalidateMode: AutovalidateMode.always,
        child: TagNameField(textEditingController: textEditingController),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.delete),
        ),
        TextButton(
          onPressed: () {
            if (updateTagFormKey.currentState?.validate() ?? false) {
              Navigator.pop(
                context,
                removeDiacritics(textEditingController.text.trim()),
              );
            }
          },
          child: Text(AppLocalizations.of(context)!.save),
        ),
      ],
    ),
  );
}
