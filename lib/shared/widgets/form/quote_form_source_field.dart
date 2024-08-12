import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class QuoteFormSourceField extends StatelessWidget {
  const QuoteFormSourceField({
    super.key,
    this.initialValue,
  });

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'source',
      initialValue: initialValue,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: context.appLocalizations.quoteFormFieldSource,
        hintText: context.appLocalizations.quoteFormFieldSourceHintText,
      ),
      keyboardType: TextInputType.text,
      smartQuotesType: SmartQuotesType.enabled,
      smartDashesType: SmartDashesType.enabled,
      valueTransformer: (value) => value?.trim(),
    );
  }
}
