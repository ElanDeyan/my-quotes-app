import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class QuoteNotFoundWithIdMessage extends StatelessWidget {
  const QuoteNotFoundWithIdMessage({
    required this.quoteId, super.key,
  });

  final int quoteId;

  @override
  Widget build(BuildContext context) {
    return Text(
      context.appLocalizations.quoteNotFoundWithId(quoteId),
    );
  }
}
