import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/screens/my_quotes/_quote_tile.dart';

class QuotesListView extends StatelessWidget {
  const QuotesListView({
    super.key,
    required this.data,
  });

  final List<Quote> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: data.length,
      semanticChildCount: data.length,
      padding: const EdgeInsets.only(
        bottom: kBottomNavigationBarHeight + kFloatingActionButtonMargin * 2,
      ),
      itemBuilder: (context, index) => QuoteTile(quote: data[index]),
    );
  }
}
