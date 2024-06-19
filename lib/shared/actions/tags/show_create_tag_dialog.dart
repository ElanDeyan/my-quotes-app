import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/helpers/nullable_extension.dart';

Future<String?>? showCreateTagDialog(
  BuildContext context, [
  String? initialValue,
]) async {
  return await showDialog<String?>(
    context: context,
    builder: (context) {
      late final TextEditingController textEditingController;

      if (initialValue.isNullOrBlank) {
        textEditingController = TextEditingController();
      } else {
        textEditingController = TextEditingController(text: initialValue);
      }

      final createTagFormKey = GlobalKey<FormState>();
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.createTag),
        content: Form(
          key: createTagFormKey,
          autovalidateMode: AutovalidateMode.always,
          child: TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.tagName,
            ),
            controller: textEditingController,
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
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              if (createTagFormKey.currentState?.validate() ?? false) {
                Navigator.pop(context, textEditingController.text.trim());
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      );
    },
  );
}
