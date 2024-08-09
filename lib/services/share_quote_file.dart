import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:my_quotes/constants/platforms.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<bool> shareQuoteFile(
  DatabaseProvider databaseProvider,
  Quote quote,
) async {
  final quoteFileAsBytes =
      utf8.encode(await quote.toShareableJsonString(databaseProvider));

  final fileName = 'quote-file-${quote.hashCode}.json';

  if (isAndroidOrIOS) {
    final directory = await getTemporaryDirectory();
    final quoteFilePath = await File('${directory.path}/$fileName').create();
    await quoteFilePath.writeAsBytes(
      quoteFileAsBytes,
    );
    try {
      final result = await Share.shareXFiles([XFile(quoteFilePath.path)]);

      return result.status == ShareResultStatus.success;
    } finally {
      await quoteFilePath.delete();
    }
  } else if (isDesktop) {
    final pathToSave = await FilePicker.platform.saveFile(
      type: FileType.custom,
      allowedExtensions: ['json'],
      lockParentWindow: true,
    );

    if (pathToSave != null) {
      final endsWithJsonExtension = p.extension(pathToSave) == '.json';
      final file = await File(
        '$pathToSave${!endsWithJsonExtension ? '.json' : ''}',
      ).create();
      await file.writeAsBytes(
        utf8.encode(await quote.toShareableJsonString(databaseProvider)),
      );

      return true;
    }
    return false;
  } else {
    final result = await runZonedGuarded(
      () async => await FileSaver.instance.saveFile(
        name: fileName,
        bytes: quoteFileAsBytes,
        mimeType: MimeType.json,
      ),
      (error, stack) {},
    );

    return result != null;
  }
}
