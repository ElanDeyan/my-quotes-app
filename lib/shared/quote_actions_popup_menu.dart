import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/screens/quote_screen.dart';
import 'package:my_quotes/screens/update_quote_screen.dart';
import 'package:url_launcher/url_launcher.dart';

PopupMenuButton<Quote> quoteActionsMenu(BuildContext context, Quote quote) {
  return PopupMenuButton(
    tooltip: 'More actions',
    position: PopupMenuPosition.under,
    itemBuilder: (context) => <PopupMenuItem<Quote>>[
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
        onTap: () => showUpdateQuoteDialog(context, quote),
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
      PopupMenuItem<Quote>(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: quote.shareableFormat))
              .then(
            (_) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied to clipboard!')),
            ),onError: (error) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error'))),
          );
        },
        child: const Row(
          children: [
            Icon(Icons.copy),
            SizedBox(
              width: 10,
            ),
            Text('Copy'),
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
    ],
  );
}
