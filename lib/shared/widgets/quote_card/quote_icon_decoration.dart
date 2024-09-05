import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuoteIconDecoration extends StatelessWidget {
  const QuoteIconDecoration({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            strokeAlign: 1,
          ),
        ),
      ),
      child: CircleAvatar(
        radius: 21,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        child: FaIcon(
          FontAwesomeIcons.quoteLeft,
          color: Theme.of(context).colorScheme.primary,
          size: 36,
        ),
      ),
    );
  }
}
