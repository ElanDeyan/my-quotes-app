import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class QuoteFormActionButton extends StatelessWidget {
  const QuoteFormActionButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      label: Text(context.appLocalizations.quoteFormActionButtonAdd),
      icon: const Icon(Icons.add_outlined),
    );
  }
}
