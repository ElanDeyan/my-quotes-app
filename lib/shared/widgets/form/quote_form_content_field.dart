import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class QuoteFormContentField extends StatelessWidget {
  const QuoteFormContentField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'content',
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: context.appLocalizations.quoteFormFieldContent,
      ),
      maxLines: null,
      smartQuotesType: SmartQuotesType.enabled,
      keyboardType: TextInputType.multiline,
      smartDashesType: SmartDashesType.enabled,
      validator: FormBuilderValidators.required(
        errorText: context.appLocalizations.nonEmptyField(
          context.appLocalizations.quoteFormFieldContent,
        ),
      ),
      valueTransformer: (value) => value?.trim(),
    );
  }
}
