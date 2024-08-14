import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/shared/actions/quotes/quote_actions.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

class QuoteTile extends StatelessWidget {
  const QuoteTile({
    super.key,
    required this.quote,
  });

  final Quote quote;

  String get _subtitle => quote.source.isNotNullOrBlank
      ? '${quote.author}, ${quote.source}'
      : quote.author;

  @override
  Widget build(BuildContext context) {
    final databaseProvider =
        Provider.of<DatabaseProvider>(context, listen: false);

    return ListTile(
      onTap: () => context.pushNamed(
        quoteByIdNavigationKey,
        pathParameters: {'id': quote.id!.toString()},
      ),
      leading: quote.isFavorite
          ? const Icon(Icons.favorite_outline)
          : const Icon(Icons.format_quote_outlined),
      title: Text(
        quote.content,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
      subtitle: Text(_subtitle),
      trailing: PopupMenuButton(
        tooltip: context.appLocalizations.quoteActionsPopupButtonTooltip,
        position: PopupMenuPosition.under,
        itemBuilder: (context) => QuoteActions.popupMenuItems(
          context.appLocalizations,
          databaseProvider,
          context,
          quote,
          actions: QuoteActions.values.where(
            (action) => switch (action) {
              QuoteActions.create => false,
              _ => true,
            },
          ),
        ),
      ),
    );
  }
}
