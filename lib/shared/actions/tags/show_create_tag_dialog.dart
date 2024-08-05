import 'package:basics/basics.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/shared/widgets/tag_name_field.dart';

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
          child: TagNameField(textEditingController: textEditingController),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              if (createTagFormKey.currentState?.validate() ?? false) {
                Navigator.pop(
                  context,
                  removeDiacritics(textEditingController.text.trim()),
                );
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      );
    },
  );
}
