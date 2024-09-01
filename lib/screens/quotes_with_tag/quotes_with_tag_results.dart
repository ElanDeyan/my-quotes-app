import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/routes/routes_names.dart';

class QuotesWithTagResults extends StatelessWidget {
  const QuotesWithTagResults({
    super.key,
    required this.quotes,
  });

  final List<Quote> quotes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: quotes.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.format_quote),
        title: Text(
          quotes[index].content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          quotes[index].author,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => context.goNamed(
          quoteByIdNavigationKey,
          pathParameters: {'id': '${quotes[index].id}'},
        ),
      ),
    );
  }
}
