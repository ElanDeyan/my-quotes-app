import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/constants/tag_name_regexp.dart';

class TagNameField extends StatelessWidget {
  const TagNameField({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: AppLocalizations.of(context)!.tagName,
        helperText: AppLocalizations.of(context)!.tagNameFieldHint,
        helperMaxLines: 3,
      ),
      controller: textEditingController,
      validator: (value) {
        if (value == null) {
          return AppLocalizations.of(context)!.requiredFieldAlert;
        }

        if (value.isBlank) {
          return AppLocalizations.of(context)!.emptyOrBlankAlert;
        }

        if (value.isNotNullOrBlank && value.contains(idSeparatorChar)) {
          return AppLocalizations.of(context)!.disallowedCommasAlert;
        }

        if (value.isNotNullOrBlank && !tagNameRegExp.hasMatch(value)) {
          return AppLocalizations.of(context)!.tagNameFieldRules;
        }

        return null;
      },
    );
  }
}
