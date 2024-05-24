import 'package:flutter/material.dart';
import 'package:my_quotes/screens/home/random_quote.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_pro/shimmer_pro.dart';

class RandomQuoteContainer extends StatelessWidget {
  const RandomQuoteContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) => FutureBuilder(
        future: database.randomQuote,
        builder: (context, snapshot) {
          final connectionState = snapshot.connectionState;
          switch (connectionState) {
            case ConnectionState.none:
              return Text(
                'No database found.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              );
            case ConnectionState.active:
              return const Text('Getting data');
            case ConnectionState.waiting:
              return Center(
                child: ShimmerPro.sized(
                  light: ShimmerProLight.lighter,
                  scaffoldBackgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  height: 100,
                  width: 200,
                ), // TODO: add better shimmer effect
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('An error occurred: ${snapshot.error}.');
              }
              final quote = snapshot.data;

              return quote == null
                  ? const Text("You don't have quotes added yet.")
                  : RandomQuote(
                      quote: quote,
                    );
          }
        },
      ),
    );
  }
}
