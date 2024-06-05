import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/shared/quote_actions.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

class RandomQuoteCard extends StatelessWidget {
  const RandomQuoteCard({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 250),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
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
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Text(
                        quote.content,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '- ${quote.author}'
                    '${quote.hasSource ? ', ${quote.source}.' : ''}',
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<DatabaseProvider>(
                    builder: (context, database, child) => FutureBuilder(
                      future: database.getTagsByIds(quote.tagsId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (!snapshot.hasError) {
                            return Wrap(
                              runSpacing: 5.0,
                              spacing: 5.0,
                              children: [
                                for (final tag in snapshot.data!)
                                  Text(
                                    '#${tag.name}',
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontSize,
                                    ),
                                  ),
                              ],
                            );
                          }
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: PopupMenuButton(
              position: PopupMenuPosition.under,
              itemBuilder: (context) => QuoteActions.popupMenuItems(
                context,
                quote,
                actions: QuoteActions.values.where(
                  (action) => switch (action) {
                    QuoteActions.create ||
                    QuoteActions.share ||
                    QuoteActions.delete =>
                      false,
                    _ => true
                  },
                ),
              ),
            ),
          ),
          const Positioned(
            top: -15,
            left: -10,
            child: FaIcon(
              FontAwesomeIcons.quoteLeft,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }
}
