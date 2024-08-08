import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:my_quotes/constants/platforms.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> quoteToFile(DatabaseProvider databaseProvider, Quote quote) async {
  if (isDesktop) {
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
    }
  } else if (isAndroidOrIOS) {
    final directory = await getTemporaryDirectory();
    final quoteFilePath =
        await File('${directory.path}/quote-file-${quote.id}.json').create();
    await quoteFilePath.writeAsBytes(
      utf8.encode(await quote.toShareableJsonString(databaseProvider)),
    );
    await Share.shareXFiles([XFile(quoteFilePath.path)]);

    await quoteFilePath.delete();
  }
}
