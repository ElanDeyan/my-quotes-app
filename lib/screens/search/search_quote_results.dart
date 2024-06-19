import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/shared/actions/quotes/quote_actions.dart';

class SearchQuoteResults extends StatelessWidget {
  const SearchQuoteResults({super.key, required this.searchResults});

  final List<Quote> searchResults;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            searchResults[index].content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            searchResults[index].author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: PopupMenuButton(
            tooltip:
                AppLocalizations.of(context)!.quoteActionsPopupButtonTooltip,
            position: PopupMenuPosition.under,
            itemBuilder: (context) => QuoteActions.popupMenuItems(
              context,
              searchResults[index],
              actions: QuoteActions.values.where(
                (action) => switch (action) {
                  QuoteActions.create => false,
                  _ => true,
                },
              ),
            ),
          ),
          onTap: () {
            context.pushNamed(
              quoteByIdNavigationKey,
              pathParameters: {'id': '${searchResults[index].id}'},
            );
          },
        ),
      ),
    );
  }
}
