import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class AnErrorOccurredMessage extends StatelessWidget {
  const AnErrorOccurredMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(context.appLocalizations.errorOccurred);
  }
}
