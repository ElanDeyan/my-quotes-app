import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class QuoteFormSourceUriField extends StatelessWidget {
  const QuoteFormSourceUriField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'sourceUri',
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: context.appLocalizations.quoteFormFieldSourceUri,
        hintText: context.appLocalizations.quoteFormFieldSourceUriHintText,
      ),
      validator: FormBuilderValidators.url(),
      smartDashesType: SmartDashesType.enabled,
      smartQuotesType: SmartQuotesType.enabled,
      keyboardType: TextInputType.url,
      valueTransformer: (value) => value?.trim(),
    );
  }
}
