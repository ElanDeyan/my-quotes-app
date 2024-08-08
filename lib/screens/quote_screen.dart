import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/shared/actions/quotes/show_update_quote_dialog.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';
import 'package:my_quotes/shared/widgets/quote_card.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_pro/shimmer_pro.dart';

final class QuoteScreen extends StatelessWidget {
  const QuoteScreen({
    super.key,
    required this.quoteId,
  });

  final int quoteId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.appLocalizations.quoteInfo),
        leading: BackButton(
          onPressed: () => context.canPop()
              ? context.pop()
              : context.pushNamed(myQuotesNavigationKey),
        ),
      ),
      body: ViewQuotePage(quoteId: quoteId),
    );
  }
}

Future<void> showQuoteInfoDialog(BuildContext context, Quote quote) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.info),
      scrollable: true,
      title: Text(context.appLocalizations.quoteInfo),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: QuoteScreenDialogBody(quoteId: quote.id!),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
            showUpdateQuoteDialog(context, quote);
          },
          child: Text(context.appLocalizations.edit),
        ),
        OutlinedButton(
          onPressed: () => context.pop(),
          child: Text(context.appLocalizations.ok),
        ),
      ],
    ),
  );
}

class ViewQuotePage extends StatelessWidget {
  const ViewQuotePage({
    super.key,
    required this.quoteId,
  });

  final int quoteId;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8.0),
      child: Center(
        child: Consumer<DatabaseProvider>(
          builder: (context, database, child) => FutureBuilder(
            future: database.getQuoteById(quoteId),
            builder: (context, snapshot) {
              final connectionState = snapshot.connectionState;

              switch (connectionState) {
                case ConnectionState.none:
                  return Text(
                    context.appLocalizations.noDatabaseConnectionMessage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  );
                case ConnectionState.active || ConnectionState.waiting:
                  final isDarkTheme =
                      MediaQuery.platformBrightnessOf(context) ==
                          Brightness.dark;

                  return ShimmerPro.sized(
                    scaffoldBackgroundColor:
                        Theme.of(context).colorScheme.surface,
                    light: isDarkTheme ? ShimmerProLight.lighter : null,
                    height: 200,
                    width: 300,
                  );

                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    final data = snapshot.data;
                    if (data == null) {
                      return Text(
                        context.appLocalizations.quoteNotFoundWithId(quoteId),
                      );
                    } else {
                      final quote = data;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width * 0.9,
                            ),
                            child: QuoteCard(
                              quote: quote,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            quote
                                .createdAtLocaleMessageOf(
                                  Locale(appLocalizations.localeName),
                                )
                                .capitalize(),
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
                      );
                    }
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}

class QuoteScreenDialogBody extends StatelessWidget {
  const QuoteScreenDialogBody({
    super.key,
    required this.quoteId,
  });

  final int quoteId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Consumer<DatabaseProvider>(
          builder: (context, database, child) => FutureBuilder(
            future: database.getQuoteById(quoteId),
            builder: (context, snapshot) {
              final connectionState = snapshot.connectionState;

              switch (connectionState) {
                case ConnectionState.none:
                  return Text(
                    context.appLocalizations.noDatabaseConnectionMessage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  );
                case ConnectionState.active || ConnectionState.waiting:
                  final isDarkTheme =
                      Theme.of(context).brightness == Brightness.dark;

                  return Center(
                    child: ShimmerPro.generated(
                      light: isDarkTheme ? ShimmerProLight.lighter : null,
                      scaffoldBackgroundColor:
                          Theme.of(context).colorScheme.surface,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var i = 0; i < 10; i++)
                              ShimmerPro.text(
                                scaffoldBackgroundColor:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                case ConnectionState.done:
                  final data = snapshot.data;
                  if (data == null) {
                    return Text(
                      context.appLocalizations.quoteNotFoundWithId(quoteId),
                    );
                  } else {
                    final quote = data;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            future: database.getTagsByIds(quote.tagsId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
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
                                return ShimmerPro.text(
                                  scaffoldBackgroundColor:
                                      Theme.of(context).colorScheme.onSurface,
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
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
