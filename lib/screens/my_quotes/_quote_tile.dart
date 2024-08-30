import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/shared/actions/quotes/quote_actions.dart';
import 'package:my_quotes/states/service_locator.dart';

class QuoteTile extends StatefulWidget {
  const QuoteTile({
    super.key,
    required this.quote,
  });

  final Quote quote;

  @override
  State<QuoteTile> createState() => _QuoteTileState();
}

class _QuoteTileState extends State<QuoteTile>
    with AutomaticKeepAliveClientMixin {
  String get _subtitle => widget.quote.source.isNotNullOrBlank
      ? '${widget.quote.author}, ${widget.quote.source}'
      : widget.quote.author;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListTile(
      onTap: () => context.pushNamed(
        quoteByIdNavigationKey,
        pathParameters: {'id': widget.quote.id!.toString()},
      ),
      leading: widget.quote.isFavorite
          ? const Icon(Icons.favorite_outline)
          : const Icon(Icons.format_quote_outlined),
      title: Text(
        widget.quote.content,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
      subtitle: Text(
        _subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: PopupMenuButton(
        tooltip: context.appLocalizations.quoteActionsPopupButtonTooltip,
        position: PopupMenuPosition.under,
        itemBuilder: (context) => QuoteActions.popupMenuItems(
          context.appLocalizations,
          serviceLocator<AppRepository>(),
          context,
          widget.quote,
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
