import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';
import 'package:my_quotes/shared/widgets/quote_card/quote_card.dart';

class QuoteCardWithExtraData extends StatelessWidget {
  const QuoteCardWithExtraData({
    super.key,
    required this.quote,
    required this.appLocalizations,
  });

  final Quote quote;
  final AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FractionallySizedBox(
          widthFactor: 0.9,
          child: QuoteCard(quote: quote),
        ),
        const SizedBox(height: 16),
        Text(
          quote
              .createdAtLocaleMessageOf(
                Locale(appLocalizations.localeName),
              )
              .capitalize(),
        ),
        if (quote.isFavorite)
          IconWithLabel(
            icon: const Icon(Icons.star),
            horizontalGap: 10,
            label: Text(
              context.appLocalizations.isFavorite(
                quote.isFavorite.toString(),
              ),
            ),
          ),
      ],
    );
  }
}
