import 'package:flutter/material.dart';
import 'package:my_quotes/constants/enums/form_types.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class QuoteFormActionButton extends StatelessWidget {
  const QuoteFormActionButton({
    super.key,
    required this.onPressed,
    this.formType = FormTypes.add,
  });

  final VoidCallback onPressed;
  final FormTypes formType;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      label: formType == FormTypes.update
          ? Text(context.appLocalizations.quoteFormActionButtonEdit)
          : Text(context.appLocalizations.quoteFormActionButtonAdd),
      icon: formType == FormTypes.update
          ? const Icon(Icons.edit_outlined)
          : const Icon(Icons.add_outlined),
    );
  }
}
