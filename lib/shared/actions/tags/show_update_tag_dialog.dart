import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/nullable_extension.dart';

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
        child: TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.newTagName,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value.isNull) {
              return AppLocalizations.of(context)!.requiredFieldAlert;
            }

            if (value?.isBlank ?? true) {
              return AppLocalizations.of(context)!.emptyOrBlankAlert;
            }

            if (value.isNotNullOrBlank && value!.contains(idSeparatorChar)) {
              return AppLocalizations.of(context)!.disallowedCommasAlert;
            }

            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.delete),
        ),
        TextButton(
          onPressed: () {
            if (updateTagFormKey.currentState?.validate() ?? false) {
              Navigator.pop(context, textEditingController.text);
            }
          },
          child: Text(AppLocalizations.of(context)!.save),
        ),
      ],
    ),
  );
}
