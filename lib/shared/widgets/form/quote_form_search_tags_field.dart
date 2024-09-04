import 'package:flutter/material.dart';

class QuoteFormSearchTagsField extends TextField {
  const QuoteFormSearchTagsField({
    super.key,
    super.decoration,
  }) : super(
          autocorrect: true,
          enableSuggestions: true,
          keyboardType: TextInputType.text,
          smartDashesType: SmartDashesType.enabled,
          smartQuotesType: SmartQuotesType.enabled,
        );
}
