import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/constants/platforms.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/widgets/shareable_quote_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

Future<void> quoteToImage(BuildContext context, Quote quote) async {
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
      if (isWeb) {
        await Share.shareXFiles([XFile.fromData(image)]);
      } else if (isDesktop) {
        final pathToSave = await FilePicker.platform.saveFile(
          type: FileType.image,
          lockParentWindow: true,
        );

        if (pathToSave != null) {
          final file = await File(pathToSave).create();
          await file.writeAsBytes(image.toList());
        }
      } else if (isAndroidOrIOS) {
        final directory = await getApplicationDocumentsDirectory();

        final quoteFilePath = await File(
          '${directory.path}/quote-file-${quote.id}.png',
        ).create();

        await quoteFilePath.writeAsBytes(image);

        await Share.shareXFiles(
          [XFile(quoteFilePath.path, bytes: image)],
        );

        await quoteFilePath.delete();
      }
    },
  );
}
