import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class QuoteFormIsFavoriteField extends StatelessWidget {
  const QuoteFormIsFavoriteField({
    super.key,
    this.initialValue = false,
  });

  final bool initialValue;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FormBuilderCheckbox(
        name: 'isFavorite',
        initialValue: initialValue,
        title: Text(context.appLocalizations.quoteFormFieldIsFavorite),
        checkColor: Colors.transparent,
        valueTransformer: (value) => value ?? false,
      ),
    );
  }
}
