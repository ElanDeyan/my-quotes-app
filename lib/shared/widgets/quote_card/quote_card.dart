import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/shared/actions/quotes/quote_actions.dart';
import 'package:my_quotes/shared/widgets/quote_card/quote_icon_decoration.dart';
import 'package:my_quotes/states/service_locator.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({
    super.key,
    required this.quote,
    this.showActions = true,
  });

  final Quote quote;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 500,
        maxHeight: 250,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card.outlined(
            clipBehavior: Clip.none,
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
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: AnimatedSize(
                        duration: Durations.short4,
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
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  AnimatedSize(
                    duration: Durations.short4,
                    child: Text(
                      '- ${quote.author}'
                      '${quote.hasSource ? ', ${quote.source}.' : '.'}',
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodySmall!.fontSize,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AnimatedSize(
                    duration: Durations.short4,
                    child: FutureBuilder(
                      future: serviceLocator<AppRepository>()
                          .getTagsByIds(quote.tagsId),
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
            bottom: -2.25,
            right: -2.25,
            child: AnimatedSwitcher(
              duration: Durations.short4,
              child: IconButton(
                onPressed: () {},
                iconSize: 16,
                icon: Icon(
                  quote.isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 16,
                ),
              ),
            ),
          ),
          if (showActions)
            Positioned(
              top: -3.75,
              right: -1,
              child: PopupMenuButton(
                tooltip: appLocalizations.quoteActionsPopupButtonTooltip,
                icon: const Icon(Icons.more_horiz_outlined),
                position: PopupMenuPosition.under,
                itemBuilder: (context) => QuoteActions.popupMenuItems(
                  appLocalizations,
                  serviceLocator<AppRepository>(),
                  context,
                  quote,
                  actions: QuoteActions.values.where(
                    (action) => switch (action) {
                      QuoteActions.create || QuoteActions.delete => false,
                      _ => true
                    },
                  ),
                ),
              ),
            ),
          const Positioned(
            top: -16.25,
            left: -16.25,
            child: QuoteIconDecoration(),
          ),
        ],
      ),
    );
  }
}
