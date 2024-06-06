import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/screens/quote_screen.dart';
import 'package:my_quotes/shared/copy_to_clipboard.dart';
import 'package:my_quotes/shared/delete_quote.dart';
import 'package:my_quotes/shared/icon_with_label.dart';
import 'package:my_quotes/shared/show_add_quote_dialog.dart';
import 'package:my_quotes/shared/show_update_quote_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

enum QuoteActions {
  info(icon: Icon(Icons.info), label: Text('Info'), name: 'Info'),
  readMore(icon: Icon(Icons.visibility), label: Text('View quote'), name: 'View quote'),
  create(icon: Icon(Icons.create), label: Text('Create'), name: 'Create'),
  update(icon: Icon(Icons.edit), label: Text('Edit'), name: 'Edit'),
  copy(icon: Icon(Icons.copy), label: Text('Copy'), name: 'Copy'),
  share(icon: Icon(Icons.share), label: Text('Share'), name: 'Share'),
  copyLink(icon: Icon(Icons.link), label: Text('Copy link'), name: 'Copy link'),
  goToLink(
    icon: Icon(Icons.open_in_new),
    label: Text('Go to link'),
    name: 'Go to link',
  ),
  delete(icon: Icon(Icons.delete), label: Text('Delete'), name: 'Delete');

  const QuoteActions({
    required this.icon,
    required this.label,
    required this.name,
  });

  final Icon icon;
  final Widget label;
  final String name;

  @override
  String toString() {
    return label.toString();
  }

  static List<QuoteActions> availableActions(
    Quote quote, {
    Iterable<QuoteActions> actions = QuoteActions.values,
  }) =>
      actions.where(quote.can).toList();

  static PopupMenuButton<Quote> popupMenuButton(
    BuildContext context,
    Quote quote,
  ) =>
      PopupMenuButton(
        position: PopupMenuPosition.under,
        itemBuilder: (context) => popupMenuItems(context, quote).toList(),
      );

  static List<PopupMenuItem<Quote>> popupMenuItems(
    BuildContext context,
    Quote quote, {
    Iterable<QuoteActions> actions = QuoteActions.values,
  }) =>
      availableActions(quote, actions: actions)
          .map(
            (action) => PopupMenuItem(
              value: quote,
              onTap: switch (action) {
                QuoteActions.readMore => () => context
                    .pushNamed('quote', pathParameters: {'id': '${quote.id!}'}),
                QuoteActions.create => () => showAddQuoteDialog(context),
                QuoteActions.info => () => showQuoteInfoDialog(context, quote),
                QuoteActions.delete => () => deleteQuote(context, quote),
                QuoteActions.copy => () =>
                    copyToClipBoard(quote.shareableFormat),
                QuoteActions.copyLink => () =>
                    copyToClipBoard(quote.sourceUri ?? ''),
                QuoteActions.share => () => Share.share(quote.shareableFormat),
                QuoteActions.goToLink => () =>
                    launchUrl(Uri.parse(quote.sourceUri!)),
                QuoteActions.update => () =>
                    showUpdateQuoteDialog(context, quote),
              },
              child: IconWithLabel(
                icon: action.icon,
                horizontalGap: 10,
                label: action.label,
              ),
            ),
          )
          .toList();
}
