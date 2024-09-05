import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/repository/interfaces/app_repository.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/shared/actions/quotes/quote_actions.dart';
import 'package:my_quotes/shared/widgets/gap.dart';
import 'package:my_quotes/shared/widgets/quote_card/quote_card.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            child: QuoteCard(key: const Key('quote_card'), quote: _quote),
          ),
          const Gap.vertical(spacing: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton(
                key: const Key('update_random_quote_button'),
                onPressed: _updateRandomQuote,
                child: const Icon(Icons.shuffle),
              ),
              OutlinedButton(
                key: const Key('share_quote_button'),
                onPressed: QuoteActions.actionCallback(
                  context.appLocalizations,
                  serviceLocator<AppRepository>(),
                  context,
                  QuoteActions.share,
                  _quote,
                ),
                child: const Icon(Icons.share_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
