import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class NoQuoteWithIdMessage extends StatelessWidget {
  const NoQuoteWithIdMessage({
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
