import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/constants/platforms.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/services/quote_to_file.dart';
import 'package:my_quotes/services/quote_to_image.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:share_plus/share_plus.dart';

enum ShareActions {
  text(debugLabel: 'text', icon: Icon(Icons.short_text_outlined)),
  image(debugLabel: 'image', icon: Icon(Icons.image_outlined)),
  link(debugLabel: 'link', icon: Icon(Icons.link_outlined)),
  file(debugLabel: 'file', icon: Icon(Icons.file_copy_outlined));

  const ShareActions({required this.debugLabel, required this.icon});

  final String debugLabel;
  final Icon icon;

  static List<ShareActions> availableActions(
    Quote quote, {
    List<ShareActions> actions = ShareActions.values,
  }) {
    return actions.where(
      (action) {
        if (action == ShareActions.link && !quote.hasSourceUri) return false;
        if (action == ShareActions.image && isWeb) return false;
        // TODO: Adds handling for web (just downloads the file)
        if (action == ShareActions.file && isWeb) return false;
        return true;
      },
    ).toList();
  }

  static VoidCallback actionCallback(
    BuildContext context,
    DatabaseProvider databaseProvider,
    AppLocalizations appLocalizations,
    ShareActions action,
    Quote quote,
  ) =>
      switch (action) {
        ShareActions.text => () async =>
            await Share.share(quote.shareableFormatOf(appLocalizations)),
        ShareActions.link => () => Share.share(quote.sourceUri!),
        ShareActions.image => () => quoteToImage(context, quote),
        ShareActions.file => () => quoteToFile(databaseProvider, quote),
      };
}
