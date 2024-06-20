import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_quotes/constants/platforms.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/shared/widgets/shareable_quote_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
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
        if (action == ShareActions.image && (isLinux || isWeb)) return false;
        if (action == ShareActions.file) return false;
        return true;
      },
    ).toList();
  }

  static VoidCallback actionCallback(
    BuildContext context,
    ShareActions action,
    Quote quote,
  ) =>
      switch (action) {
        ShareActions.text => () =>
            Share.share(quote.shareableFormatOf(context)),
        ShareActions.link => () => Share.share(quote.sourceUri!),
        ShareActions.image => () async {
            final screenshotController = ScreenshotController();
            await screenshotController
                .captureFromWidget(
              ShareableQuoteCard(
                quote: quote,
              ),
              context: context,
              delay: Durations.medium3,
              pixelRatio: MediaQuery.devicePixelRatioOf(context),
            )
                .then(
              (image) async {
                final directory = await getApplicationDocumentsDirectory();
                final imagePath =
                    await File('${directory.path}/quote-${quote.id!}.png')
                        .create();
                await imagePath.writeAsBytes(image);

                await Share.shareXFiles([XFile(imagePath.path, bytes: image)]);
              },
            );
          },
        ShareActions.file => () => throw UnimplementedError()
      };
}
