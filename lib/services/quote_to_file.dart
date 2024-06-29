import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/constants/platforms.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> quoteToFile(BuildContext context, Quote quote) async {
  if (isDesktop) {
    final pathToSave = await FilePicker.platform.saveFile(
      type: FileType.custom,
      allowedExtensions: ['json'],
      lockParentWindow: true,
    );

    if (pathToSave != null) {
      final file = await File(pathToSave).create();
      if (context.mounted) {
        await file.writeAsString(await quote.toShareableJsonString(context));
      }
    }
  } else if (isAndroidOrIOS) {
    final directory = await getApplicationDocumentsDirectory();
    final quoteFilePath =
        await File('${directory.path}/quote-file-${quote.id!}.json').create();
    if (context.mounted) {
      await quoteFilePath
          .writeAsString(await quote.toShareableJsonString(context));

      await Share.shareXFiles([XFile(quoteFilePath.path)]);

      await quoteFilePath.delete();
    }
  }
}
