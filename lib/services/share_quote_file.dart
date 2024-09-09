import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:my_quotes/constants/platforms.dart';
import 'package:my_quotes/constants/quote_file_extension.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/repository/interfaces/app_repository.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<bool> shareQuoteFile(
  AppRepository appRepository,
  Quote quote,
) async {
  final quoteFileAsBytes =
      utf8.encode(await quote.toShareableJsonString(appRepository));

  final fileName = 'quote-file-${quote.hashCode}$quoteFileExtension';

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
      final endsWithJsonExtension =
          p.extension(pathToSave, 2) == quoteFileExtension;
      final file = await File(
        '$pathToSave${!endsWithJsonExtension ? quoteFileExtension : ''}',
      ).create();
      await file.writeAsBytes(
        utf8.encode(await quote.toShareableJsonString(appRepository)),
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
