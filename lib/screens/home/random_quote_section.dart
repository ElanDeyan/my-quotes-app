import 'package:flutter/material.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/screens/home/random_quote_container.dart';
import 'package:my_quotes/shared/widgets/an_error_occurred_message.dart';
import 'package:my_quotes/shared/widgets/no_database_connection_message.dart';
import 'package:my_quotes/shared/widgets/no_quotes_added_yet_message.dart';
import 'package:my_quotes/shared/widgets/quote_card_skeleton.dart';
import 'package:my_quotes/states/service_locator.dart';

class RandomQuoteSection extends StatelessWidget {
  const RandomQuoteSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: serviceLocator<AppRepository>().allQuotesStream,
      builder: (context, snapshot) {
        final connectionState = snapshot.connectionState;
        final hasError = snapshot.hasError;
        final hasData = snapshot.hasData;

        final data = snapshot.data;

        return switch ((connectionState, hasError, hasData)) {
          (ConnectionState.none, _, _) => const NoDatabaseConnectionMessage(),
          (ConnectionState.waiting, _, _) => const RepaintBoundary(
              child: QuoteCardSkeleton(key: Key('quote_card_skeleton')),
            ),
          (ConnectionState.active || ConnectionState.done, _, true)
              when data == null =>
            const NoQuotesAddedYetMessage(),
          (ConnectionState.active || ConnectionState.done, _, true)
              when data != null =>
            RandomQuoteContainer(
              key: const Key('random_quote_container'),
              quotes: data..shuffle(),
            ),
          _ => const AnErrorOccurredMessage(),
        };
      },
    );
  }
}
