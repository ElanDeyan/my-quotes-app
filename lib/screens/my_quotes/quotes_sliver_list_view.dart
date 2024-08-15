import 'dart:developer';
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
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: quotes.length,
      itemBuilder: (context, index) {
        log('rendering item #$index', name: 'QuotesListView');
        return QuoteTile(quote: quotes[index]);
      },
    );
  }
}
