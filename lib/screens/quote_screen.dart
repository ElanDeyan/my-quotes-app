import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/nullable_extension.dart';
import 'package:my_quotes/screens/update_quote_screen.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_pro/shimmer_pro.dart';

final class QuoteScreen extends StatelessWidget {
  const QuoteScreen({
    super.key,
    required this.quoteId,
  });

  final int quoteId;

  static const screenName = 'Quote';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.goNamed('mainScreen'),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: QuoteScreenBody(quoteId: quoteId),
    );
  }
}

Future<void> showQuoteInfoModal(BuildContext context, Quote quote) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (context) => QuoteScreenBody(quoteId: quote.id!),
  );
}

Future<void> showQuoteInfoDialog(BuildContext context, Quote quote) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            showUpdateQuoteModal(context, quote);
          },
          child: const Text('Edit'),
        ),
      ],
      content: QuoteScreenBody(quoteId: quote.id!),
    ),
  );
}

class QuoteScreenBody extends StatelessWidget {
  const QuoteScreenBody({
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
                    'No database found',
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
                  if (data.isNull) {
                    return const Text('Quote not found');
                  } else {
                    final quote = data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Quote info',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text('Id: ${quote.id!}'),
                        Text('Content: ${quote.content}'),
                        Text('Author: ${quote.author}'),
                        if (quote.source.isNotNull)
                          Text('Source: ${quote.source!}'),
                        if (quote.sourceUri.isNotNull)
                          Text('Link: ${quote.sourceUri}'),
                        Text('Created at: ${quote.createdAt!.toLocal()}'),
                        Text('Tags: ${quote.tags ?? 'No tags added'}'),
                        Text(
                          'Is favorite? ${quote.isFavorite! ? 'Yes' : 'No'}',
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
