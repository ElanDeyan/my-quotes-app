import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/main.dart';
import 'package:my_quotes/shared/actions/quotes/quote_actions.dart';
import 'package:my_quotes/shared/widgets/gap.dart';
import 'package:my_quotes/shared/widgets/quote_card.dart';

class RandomQuoteContainer extends StatefulWidget {
  const RandomQuoteContainer({super.key, required this.quotes});

  final List<Quote> quotes;

  @override
  State<RandomQuoteContainer> createState() => _RandomQuoteContainerState();
}

class _RandomQuoteContainerState extends State<RandomQuoteContainer> {
  late Quote _quote;

  late final int _lastIndex;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _lastIndex = widget.quotes.length - 1;
    _quote = widget.quotes[_index];
  }

  void _updateRandomQuote() => setState(() {
        if (_index == _lastIndex) {
          _index = 0;
        } else {
          _index++;
        }
        _quote = widget.quotes[_index];
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: QuoteCard(quote: _quote),
        ),
        const Gap.vertical(spacing: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              onPressed: _updateRandomQuote,
              child: const Icon(Icons.shuffle),
            ),
            const Gap.horizontal(spacing: 10),
            OutlinedButton(
              onPressed: QuoteActions.actionCallback(
                context.appLocalizations,
                databaseLocator,
                context,
                QuoteActions.share,
                _quote,
              ),
              child: const Icon(Icons.share_outlined),
            ),
          ],
        ),
      ],
    );
  }
}
