import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/nullable_extension.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/shared/quotes/quote_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_platform/universal_platform.dart';

Future<void> showShareActions(BuildContext context, Quote quote) {
  final screenshotController = ScreenshotController();

  Screenshot(
    controller: screenshotController,
    child: QuoteCard(
      quote: quote,
      showActions: false,
    ),
  );

  final isAndroidOrIOS = UniversalPlatform.isAndroid || UniversalPlatform.isIOS;

  return showModalBottomSheet<void>(
    context: context,
    builder: (context) => BottomSheet(
      onClosing: () {},
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share this quote',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              ),
            ),
            Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: 10,
              children: [
                if (!UniversalPlatform.isLinux)
                  TextButton.icon(
                    onPressed: () async {
                      await screenshotController
                          .capture(
                        pixelRatio: MediaQuery.devicePixelRatioOf(context),
                      )
                          .then((Uint8List? image) async {
                        if (image.isNotNull) {
                          final directory =
                              await getApplicationDocumentsDirectory();
                          final imagePath = await File(
                            '${directory.path}/quote-${quote.id!}-screenshot.png',
                          ).create();

                          print(imagePath.absolute);

                          await imagePath.writeAsBytes(image!);

                          await Share.shareXFiles(
                            [XFile(imagePath.path)],
                            text: 'Look at this quote',
                          );
                        }
                      });
                    },
                    label: const Text('Image'),
                    icon: const Icon(Icons.image_outlined),
                  ),
                TextButton.icon(
                  onPressed: () => Share.share(quote.shareableFormat),
                  icon: const Icon(Icons.short_text_outlined),
                  label: const Text('Text'),
                ),
                if (isAndroidOrIOS && quote.hasSourceUri)
                  TextButton.icon(
                    onPressed: () =>
                        Share.shareUri(Uri.parse(quote.sourceUri!)),
                    label: const Text('Quote link'),
                    icon: const Icon(Icons.link_outlined),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
