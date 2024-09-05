import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/repository/interfaces/app_repository.dart';
import 'package:my_quotes/shared/actions/quotes/share_actions.dart';

Future<void> showQuoteShareActions(
  AppLocalizations appLocalizations,
  AppRepository appRepository,
  BuildContext context,
  Quote quote,
) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (context) => BottomSheet(
      onClosing: () {},
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 10.0,
          runSpacing: 10.0,
          children: ShareActions.availableActions(quote)
              .map(
                (action) => TextButton.icon(
                  onPressed: ShareActions.actionCallback(
                    context,
                    appRepository,
                    appLocalizations,
                    action,
                    quote,
                  ),
                  label: Text(action.debugLabel),
                  icon: action.icon,
                ),
              )
              .toList(),
        ),
      ),
    ),
  );
}
