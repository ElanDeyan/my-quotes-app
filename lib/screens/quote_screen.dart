import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
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
        title: Text(AppLocalizations.of(context)!.quoteInfo),
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
      title: Text(AppLocalizations.of(context)!.quoteInfo),
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
          child: Text(AppLocalizations.of(context)!.edit),
        ),
        OutlinedButton(
          onPressed: () => context.pop(),
          child: Text(AppLocalizations.of(context)!.ok),
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
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8.0),
      child: Center(
        child: _quoteInfoWithCard(),
      ),
    );
  }

  Consumer<DatabaseProvider> _quoteInfoWithCard() {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) => FutureBuilder(
        future: database.getQuoteById(quoteId),
        builder: (context, snapshot) {
          final connectionState = snapshot.connectionState;

          switch (connectionState) {
            case ConnectionState.none:
              return Text(
                AppLocalizations.of(context)!.noDatabaseConnectionMessage,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              );
            case ConnectionState.active || ConnectionState.waiting:
              final isDarkTheme =
                  MediaQuery.platformBrightnessOf(context) == Brightness.dark;

              return ShimmerPro.sized(
                scaffoldBackgroundColor: Theme.of(context).colorScheme.surface,
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
                    AppLocalizations.of(context)!.quoteNotFoundWithId(quoteId),
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
                        quote.createdAtLocaleMessageOf(context).capitalize(),
                      ),
                      if (quote.isFavorite ?? false)
                        IconWithLabel(
                          icon: const Icon(Icons.star),
                          horizontalGap: 10,
                          label: Text(
                            AppLocalizations.of(context)!
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
                    AppLocalizations.of(context)!.noDatabaseConnectionMessage,
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
                      AppLocalizations.of(context)!
                          .quoteNotFoundWithId(quoteId),
                    );
                  } else {
                    final quote = data;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.quoteInfo,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text('Id: ${quote.id}'),
                        Text(
                          '${AppLocalizations.of(context)!.quoteFormFieldContent}: ${quote.content}',
                        ),
                        Text(
                          '${AppLocalizations.of(context)!.quoteFormFieldAuthor}: ${quote.author}',
                        ),
                        if (quote.source.isNotNullOrBlank)
                          Text(
                            '${AppLocalizations.of(context)!.quoteFormFieldSource}: ${quote.source!}',
                          ),
                        if (quote.sourceUri.isNotNullOrBlank)
                          Text(
                            '${AppLocalizations.of(context)!.quoteFormFieldSourceUri}: ${quote.sourceUri}',
                          ),
                        Text(
                          quote.createdAtLocaleMessageOf(context).capitalize(),
                        ),
                        if (quote.tagsId.isEmpty)
                          Text(
                            AppLocalizations.of(context)!.quoteWithoutTags,
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
                                      AppLocalizations.of(context)!.noTagsFound,
                                    );
                                  } else {
                                    final tagsNames =
                                        tags.map((tag) => tag.name).join(', ');
                                    return Text(
                                      '${AppLocalizations.of(context)!.tags}: $tagsNames',
                                    );
                                  }
                                }
                                return Text(
                                  AppLocalizations.of(context)!.noTagsFound,
                                );
                              } else {
                                return ShimmerPro.text(
                                  scaffoldBackgroundColor:
                                      Theme.of(context).colorScheme.onSurface,
                                );
                              }
                            },
                          ),
                        if (quote.isFavorite ?? false)
                          IconWithLabel(
                            icon: const Icon(Icons.star),
                            horizontalGap: 10,
                            label: Text(
                              AppLocalizations.of(context)!
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
