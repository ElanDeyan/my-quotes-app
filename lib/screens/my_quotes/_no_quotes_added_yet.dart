import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class NoQuotesAddedYet extends StatelessWidget {
  const NoQuotesAddedYet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.appLocalizations.noQuotesAddedYet),
    );
  }
}
