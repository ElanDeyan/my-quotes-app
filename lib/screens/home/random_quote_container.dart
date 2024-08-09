import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/shared/actions/quotes/quote_actions.dart';
import 'package:my_quotes/shared/widgets/an_error_occurred_message.dart';
import 'package:my_quotes/shared/widgets/no_database_connection_message.dart';
import 'package:my_quotes/shared/widgets/no_quotes_added_yet_message.dart';
import 'package:my_quotes/shared/widgets/quote_card.dart';
import 'package:my_quotes/shared/widgets/quote_card_skeleton.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

final class RandomQuoteContainer extends StatefulWidget {
  const RandomQuoteContainer({super.key});

  @override
  State<RandomQuoteContainer> createState() => _RandomQuoteContainerState();
}

final class _RandomQuoteContainerState extends State<RandomQuoteContainer> {
  @override
  Widget build(BuildContext context) {
    final databaseProvider =
        Provider.of<DatabaseProvider>(context, listen: false);

    return FutureBuilder(
      future: databaseProvider.randomQuote,
      builder: (context, snapshot) {
        final connectionState = snapshot.connectionState;
        final hasError = snapshot.hasError;
        final hasData = snapshot.hasData;

        final data = snapshot.data;

        return switch ((connectionState, hasError, hasData)) {
          (ConnectionState.none, _, _) => const NoDatabaseConnectionMessage(),
          (ConnectionState.waiting, _, _) => const QuoteCardSkeleton(),
          (ConnectionState.done, _, true) when data == null =>
            const NoQuotesAddedYetMessage(),
          (ConnectionState.done, _, true) when data != null => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: QuoteCard(
                    quote: data,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () => setState(() {}),
                      child: const Icon(Icons.shuffle_outlined),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    OutlinedButton(
                      onPressed: QuoteActions.actionCallback(
                        context.appLocalizations,
                        databaseProvider,
                        context,
                        QuoteActions.share,
                        data,
                      ),
                      child: const Icon(Icons.share_outlined),
                    ),
                  ],
                ),
              ],
            ),
          _ => const AnErrorOccurredMessage(),
        };
      },
    );
  }
}
