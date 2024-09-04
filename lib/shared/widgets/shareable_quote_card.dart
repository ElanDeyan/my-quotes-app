import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/quote_extension.dart';

class ShareableQuoteCard extends StatelessWidget {
  const ShareableQuoteCard({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Card.outlined(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(10),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 26.0,
                    right: 26.0,
                    top: 22.0,
                    bottom: 11.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        quote.content,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '\u2014 ${quote.author}'
                        '${quote.hasSource ? ', ${quote.source}.' : '.'}',
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodySmall!.fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -16.25,
                left: -16.25,
                child: CircleAvatar(
                  radius: 21,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: FaIcon(
                    FontAwesomeIcons.quoteLeft,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 36,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
