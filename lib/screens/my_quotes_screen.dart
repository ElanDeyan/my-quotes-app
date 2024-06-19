import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/actions/quotes/quote_actions.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_pro/shimmer_pro.dart';

final class MyQuotesScreen extends StatelessWidget {
  const MyQuotesScreen({
    super.key,
  });

  static const screenName = 'All quotes';

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) => FutureBuilder(
        future: database.allQuotes,
        builder: (context, snapshot) {
          final connectionState = snapshot.connectionState;

          switch (connectionState) {
            case ConnectionState.none:
              return Text(
                'No database found',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              );
            case ConnectionState.active || ConnectionState.waiting:
              final isDarkTheme =
                  Theme.of(context).brightness == Brightness.dark;
              final parentWidth = MediaQuery.of(context).size.width;

              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var i = 0; i < 10; i++)
                        ShimmerPro.sized(
                          light: isDarkTheme ? ShimmerProLight.lighter : null,
                          scaffoldBackgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          height: 50,
                          width: parentWidth,
                        ),
                    ],
                  ),
                ),
              );
            case ConnectionState.done:
              final data = snapshot.data!;
              if (data case <Quote>[]) {
                return const Center(
                  child: Text("You don't have any quotes yet"),
                );
              }
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: data.length,
                semanticChildCount: data.length,
                padding: EdgeInsets.only(
                  bottom: kBottomNavigationBarHeight,
                  left: MediaQuery.sizeOf(context).width * 0.0125,
                  right: MediaQuery.sizeOf(context).width * 0.0125,
                ),
                itemBuilder: (context, index) =>
                    QuoteTileCard(data: data[index]),
              );
          }
        },
      ),
    );
  }
}

class QuoteTileCard extends StatelessWidget {
  const QuoteTileCard({
    super.key,
    required this.data,
  });

  final Quote data;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(10),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        tileColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: const Icon(Icons.format_quote),
        title: Text(
          data.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
          fontStyle: FontStyle.italic,
        ),
        subtitle: Text(data.author),
        subtitleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
          fontWeight: FontWeight.w500,
        ),
        trailing: PopupMenuButton(
          tooltip: AppLocalizations.of(context)!.quoteActionsPopupButtonTooltip,
          position: PopupMenuPosition.under,
          itemBuilder: (context) => QuoteActions.popupMenuItems(
            context,
            data,
            actions: QuoteActions.values.where(
              (action) => switch (action) {
                QuoteActions.create => false,
                _ => true,
              },
            ),
          ),
        ),
      ),
    );
  }
}
