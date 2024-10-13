import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/services/save_quote_image.dart';
import 'package:my_quotes/services/share_quote_file.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';
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
        return true;
      },
    ).toList();
  }

  static VoidCallback actionCallback(
    BuildContext context,
    AppRepository appRepository,
    AppLocalizations appLocalizations,
    ShareActions action,
    Quote quote,
  ) =>
      switch (action) {
        ShareActions.text => () async =>
            Share.share(quote.shareableFormatOf(appLocalizations)),
        ShareActions.link => () => Share.share(quote.sourceUri!),
        ShareActions.image => () async {
            final successfulOperation = await saveQuoteImage(context, quote);

            if (context.mounted) {
              onSuccessfulOperation(
                successfulOperation: successfulOperation,
                context: context,
              );
            }
          },
        ShareActions.file => () async {
            final successfulOperation =
                await shareQuoteFile(appRepository, quote);

            if (context.mounted) {
              onSuccessfulOperation(
                successfulOperation: successfulOperation,
                context: context,
              );
            }
          },
      };

  static void onSuccessfulOperation({
    required bool successfulOperation,
    required BuildContext context,
  }) {
    if (successfulOperation) {
      if (context.mounted) {
        showToast(
          context,
          child: PillChip(
            label: Text(
              context.appLocalizations.successfulOperation,
            ),
          ),
        );
      }
    }
  }
}
