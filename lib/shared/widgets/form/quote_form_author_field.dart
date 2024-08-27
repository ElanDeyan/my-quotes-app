import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:my_quotes/constants/enums/form_types.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class QuoteFormAuthorField extends StatelessWidget {
  const QuoteFormAuthorField({
    super.key,
    this.formType = FormTypes.add,
    this.initialValue,
  });

  final FormTypes formType;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final labelText = context.appLocalizations.quoteFormFieldAuthor;
    return RepaintBoundary(
      child: FormBuilderTextField(
        name: 'author',
        initialValue: initialValue,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
        ),
        smartQuotesType: SmartQuotesType.enabled,
        keyboardType: TextInputType.name,
        smartDashesType: SmartDashesType.enabled,
        validator: FormBuilderValidators.required(
          errorText: context.appLocalizations.nonEmptyField(
            labelText,
          ),
        ),
        valueTransformer: (value) => value?.trim(),
      ),
    );
  }
}
