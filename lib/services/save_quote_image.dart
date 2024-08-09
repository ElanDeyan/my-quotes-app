import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/constants/platforms.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/widgets/shareable_quote_card.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

Future<bool> saveQuoteImage(BuildContext context, Quote quote) async {
  final screenshotController = ScreenshotController();
  final shareResult = await screenshotController
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
      final fileName = 'quote-image-${quote.hashCode}.png';
      if (isAndroidOrIOS) {
        final directory = await getApplicationDocumentsDirectory();

        final quoteFilePath = await File(
          '${directory.path}/$fileName',
        ).create();

        await quoteFilePath.writeAsBytes(image);

        try {
          final result = await Share.shareXFiles(
            [XFile(quoteFilePath.path, bytes: image)],
          );

          return result.status == ShareResultStatus.success;
        } finally {
          await quoteFilePath.delete();
        }
      } else if (isDesktop) {
        final pathToSave = await FilePicker.platform.saveFile(
          type: FileType.image,
          allowedExtensions: ['png'],
          lockParentWindow: true,
        );

        if (pathToSave != null) {
          final endsWithPngExtension = p.extension(pathToSave) == '.png';
          final file = await File(
            '$pathToSave${!endsWithPngExtension ? '.png' : ''}',
          ).create();
          await file.writeAsBytes(
            image,
          );
          return true;
        }
        return false;
      } else {
        final result = await runZonedGuarded(
          () async => await FileSaver.instance.saveFile(
            name: fileName,
            bytes: image,
            mimeType: MimeType.png,
          ),
          (error, stackTrace) {},
        );

        return result != null;
      }
    },
  );

  return shareResult;
}
