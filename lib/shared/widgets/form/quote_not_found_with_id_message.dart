import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class QuoteNotFoundWithIdMessage extends StatelessWidget {
  const QuoteNotFoundWithIdMessage({
    super.key,
    required this.quoteId,
  });

  final int quoteId;

  @override
  Widget build(BuildContext context) {
    return Text(
      context.appLocalizations.quoteNotFoundWithId(quoteId),
    );
  }
}
