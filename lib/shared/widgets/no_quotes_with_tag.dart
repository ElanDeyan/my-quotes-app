import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class NoQuotesWithTag extends StatelessWidget {
  const NoQuotesWithTag({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(context.appLocalizations.noQuotesWithTag);
  }
}
