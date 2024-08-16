import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class NoQuotesAddedYetMessage extends StatelessWidget {
  const NoQuotesAddedYetMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(context.appLocalizations.noQuotesAddedYet);
  }
}
