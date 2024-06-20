import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/shared/actions/quotes/quote_actions.dart';
import 'package:my_quotes/shared/widgets/quote_card.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_pro/shimmer_pro.dart';

final class RandomQuoteContainer extends StatefulWidget {
  const RandomQuoteContainer({super.key});

  @override
  State<RandomQuoteContainer> createState() => _RandomQuoteContainerState();
}

final class _RandomQuoteContainerState extends State<RandomQuoteContainer> {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseProvider>(context, listen: false);
    return FutureBuilder(
      future: database.randomQuote,
      builder: (context, snapshot) {
        final connectionState = snapshot.connectionState;
        switch (connectionState) {
          case ConnectionState.none:
            return Text(
              AppLocalizations.of(context)!.noDatabaseConnectionMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            );
          case ConnectionState.active || ConnectionState.waiting:
            final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
            return Center(
              child: ShimmerPro.sized(
                light: isDarkTheme ? ShimmerProLight.lighter : null,
                scaffoldBackgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                height: 100,
                width: 200,
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text(AppLocalizations.of(context)!.errorOccurred);
            }
            final quote = snapshot.data;

            if (quote == null) {
              return Text(AppLocalizations.of(context)!.noQuotesAddedYet);
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: QuoteCard(
                      quote: quote,
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
                          context,
                          QuoteActions.share,
                          quote,
                        ),
                        child: const Icon(Icons.share_outlined),
                      ),
                    ],
                  ),
                ],
              );
            }
        }
      },
    );
  }
}
