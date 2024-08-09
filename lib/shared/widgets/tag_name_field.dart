import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/constants/tag_name_regexp.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

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
        labelText: context.appLocalizations.tagName,
        helperText: context.appLocalizations.tagNameFieldHint,
        helperMaxLines: 3,
      ),
      controller: textEditingController,
      validator: (value) {
        if (value == null) {
          return context.appLocalizations.requiredFieldAlert;
        }

        if (value.isBlank) {
          return context.appLocalizations.emptyOrBlankAlert;
        }

        if (value.isNotNullOrBlank && value.contains(idSeparatorChar)) {
          return context.appLocalizations.disallowedCommasAlert;
        }

        if (value.isNotNullOrBlank && !tagNameRegExp.hasMatch(value)) {
          return context.appLocalizations.tagNameFieldRules;
        }

        return null;
      },
    );
  }
}
