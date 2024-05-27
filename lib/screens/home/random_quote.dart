import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/screens/quote_screen.dart';
import 'package:my_quotes/screens/update_quote_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class RandomQuoteCard extends StatelessWidget {
  const RandomQuoteCard({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 350),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 26.0, vertical: 22.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        quote.content,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '- ${quote.author}'
                    '${quote.hasSource ? ', ${quote.source}.' : ''}',
                    softWrap: true,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: PopupMenuButton<Quote>(
              icon: const Icon(Icons.more_vert),
              tooltip: 'More actions',
              position: PopupMenuPosition.under,
              itemBuilder: (context) => _actions(context, quote),
            ),
          ),
          const Positioned(
            top: -15,
            left: -10,
            child: FaIcon(
              FontAwesomeIcons.quoteLeft,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }

  List<PopupMenuItem<Quote>> _actions(BuildContext context, Quote quote) {
    return <PopupMenuItem<Quote>>[
      PopupMenuItem<Quote>(
        onTap: () => showQuoteInfoDialog(context, quote),
        child: const Row(
          children: [
            Icon(Icons.info),
            SizedBox(
              width: 10,
            ),
            Text('Info'),
          ],
        ),
      ),
      PopupMenuItem<Quote>(
        onTap: () => showUpdateQuoteModal(context, quote),
        child: const Row(
          children: [
            Icon(Icons.edit),
            SizedBox(
              width: 10,
            ),
            Text('Edit'),
          ],
        ),
      ),
      if (quote.hasSourceUri) ...[
        PopupMenuItem<Quote>(
          onTap: () => launchUrl(Uri.parse(quote.sourceUri!)),
          child: const Row(
            children: [
              Icon(Icons.open_in_new),
              SizedBox(
                width: 10,
              ),
              Text('Go to link'),
            ],
          ),
        ),
        PopupMenuItem<Quote>(
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: quote.sourceUri!)).then(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link copied to clipboard!')),
              ),
            );
          },
          child: const Row(
            children: [
              Icon(Icons.link),
              SizedBox(
                width: 10,
              ),
              Text('Copy link'),
            ],
          ),
        ),
      ],
    ];
  }
}
