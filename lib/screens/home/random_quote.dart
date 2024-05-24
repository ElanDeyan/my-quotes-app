import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/nullable_extension.dart';

final class RandomQuote extends StatelessWidget {
  const RandomQuote({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  quote.content,
                  softWrap: true,
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text('- ${quote.author}'),
                if (quote.source.isNotNull) Text(quote.source!),
              ],
            ),
          ),
        ),
        const Positioned(
          top: -10,
          left: 0,
          child: FaIcon(FontAwesomeIcons.quoteLeft),
        ),
      ],
    );
  }
}
