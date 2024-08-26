import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/screens/my_quotes/_quote_tile.dart';

class QuotesSliverListView extends StatelessWidget {
  const QuotesSliverListView({
    super.key,
    required this.quotes,
  });

  final List<Quote> quotes;

  @override
  Widget build(BuildContext context) => SliverList.builder(
        key: const Key('all_quotes_sliver_list'),
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          return QuoteTile(key: Key('quote_tile_$index'), quote: quotes[index]);
        },
      );
}
