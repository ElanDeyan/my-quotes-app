import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class NoQuoteWithIdMessage extends StatelessWidget {
  const NoQuoteWithIdMessage({
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
