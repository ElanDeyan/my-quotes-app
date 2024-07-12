import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/quote_screen.dart';
import 'package:my_quotes/shared/actions/copy_to_clipboard.dart';
import 'package:my_quotes/shared/actions/quotes/delete_quote.dart';
import 'package:my_quotes/shared/actions/quotes/show_add_quote_dialog.dart';
import 'package:my_quotes/shared/actions/quotes/show_quote_share_actions.dart';
import 'package:my_quotes/shared/actions/quotes/show_update_quote_dialog.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';
import 'package:url_launcher/url_launcher.dart';

enum QuoteActions {
  info(
    icon: Icon(Icons.info_outline),
    label: Text('Info'),
    debugLabel: 'info',
    name: 'Info',
  ),
  readMore(
    icon: Icon(Icons.visibility_outlined),
    label: Text('View quote'),
    debugLabel: 'view_quote',
    name: 'View quote',
  ),
  create(
    icon: Icon(Icons.create_outlined),
    label: Text('Create'),
    debugLabel: 'create',
    name: 'Create',
  ),
  update(
    icon: Icon(Icons.edit_outlined),
    label: Text('Edit'),
    debugLabel: 'edit',
    name: 'Edit',
  ),
  copy(
    icon: Icon(Icons.copy_outlined),
    label: Text('Copy'),
    debugLabel: 'copy',
    name: 'Copy',
  ),
  share(
    icon: Icon(Icons.share_outlined),
    label: Text('Share'),
    debugLabel: 'share',
    name: 'Share',
  ),
  copyLink(
    icon: Icon(Icons.link_outlined),
    label: Text('Copy link'),
    debugLabel: 'copy_link',
    name: 'Copy link',
  ),
  goToLink(
    icon: Icon(Icons.open_in_new_outlined),
    label: Text('Go to link'),
    debugLabel: 'go_to_link',
    name: 'Go to link',
  ),
  delete(
    icon: Icon(Icons.delete_outline),
    label: Text('Delete'),
    debugLabel: 'delete',
    name: 'Delete',
  );

  const QuoteActions({
    required this.icon,
    required this.label,
    required this.name,
    required this.debugLabel,
  });

  final Icon icon;
  final Widget label;
  final String name;
  final String debugLabel;

  @override
  String toString() {
    return label.toString();
  }

  static List<QuoteActions> availableActions(
    Quote quote, {
    Iterable<QuoteActions> actions = QuoteActions.values,
  }) =>
      actions.where(quote.canPerform).toList();

  static void Function() actionCallback(
    BuildContext context,
    QuoteActions action,
    Quote quote,
  ) =>
      switch (action) {
        QuoteActions.readMore => () => context.pushNamed(
              quoteByIdNavigationKey,
              pathParameters: {'id': '${quote.id}'},
            ),
        QuoteActions.create => () => showAddQuoteDialog(context),
        QuoteActions.info => () => showQuoteInfoDialog(context, quote),
        QuoteActions.delete => () => deleteQuote(context, quote),
        QuoteActions.copy => () =>
            copyToClipBoard(context, quote.shareableFormatOf(context)),
        QuoteActions.copyLink => () =>
            copyToClipBoard(context, quote.sourceUri ?? ''),
        QuoteActions.share => () => showQuoteShareActions(context, quote),
        QuoteActions.goToLink => () => launchUrl(Uri.parse(quote.sourceUri!)),
        QuoteActions.update => () => showUpdateQuoteDialog(context, quote)
      };

  static PopupMenuButton<Quote> popupMenuButton(
    BuildContext context,
    Quote quote,
  ) =>
      PopupMenuButton(
        tooltip: AppLocalizations.of(context)!.quoteActionsPopupButtonTooltip,
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
              onTap: QuoteActions.actionCallback(context, action, quote),
              child: IconWithLabel(
                icon: action.icon,
                horizontalGap: 10,
                label: Text(
                  AppLocalizations.of(context)!.quoteActions(action.debugLabel),
                ),
              ),
            ),
          )
          .toList();
}
