import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuoteDataListView extends StatelessWidget {
  const QuoteDataListView({
    super.key,
    required this.quote,
    required this.databaseProvider,
  });

  final Quote quote;
  final DatabaseProvider databaseProvider;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Id: ${quote.id}'),
            Text(
              '${context.appLocalizations.quoteFormFieldContent}: ${quote.content}',
            ),
            Text(
              '${context.appLocalizations.quoteFormFieldAuthor}: ${quote.author}',
            ),
            if (quote.source.isNotNullOrBlank)
              Text(
                '${context.appLocalizations.quoteFormFieldSource}: ${quote.source!}',
              ),
            if (quote.sourceUri.isNotNullOrBlank)
              Text(
                '${context.appLocalizations.quoteFormFieldSourceUri}: ${quote.sourceUri}',
              ),
            Text(
              quote
                  .createdAtLocaleMessageOf(
                    Locale(context.appLocalizations.localeName),
                  )
                  .capitalize(),
            ),
            if (quote.tagsId.isEmpty)
              Text(
                context.appLocalizations.quoteWithoutTags,
              )
            else
              FutureBuilder(
                future: databaseProvider.getTagsByIds(quote.tagsId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      final tags = snapshot.data!;
                      if (tags.isEmpty) {
                        return Text(
                          context.appLocalizations.noTagsFound,
                        );
                      } else {
                        final tagsNames =
                            tags.map((tag) => tag.name).join(', ');
                        return Text(
                          '${context.appLocalizations.tags}: $tagsNames',
                        );
                      }
                    }
                    return Text(
                      context.appLocalizations.noTagsFound,
                    );
                  } else {
                    return const Skeletonizer(
                      child: Bone.text(
                        words: 4,
                      ),
                    );
                  }
                },
              ),
            if (quote.isFavorite)
              IconWithLabel(
                icon: const Icon(Icons.star),
                horizontalGap: 10,
                label: Text(
                  context.appLocalizations
                      .isFavorite(quote.isFavorite.toString()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
