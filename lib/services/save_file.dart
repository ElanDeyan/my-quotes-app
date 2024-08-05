// TODO: removes this lib and upgrade web support
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:my_quotes/constants/platforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> saveJsonFile(XFile file, String fileName) async {
  if (isDesktop) {
    final pathToSave = await FilePicker.platform.saveFile(
      type: FileType.custom,
      allowedExtensions: ['json'],
      lockParentWindow: true,
    );

    if (pathToSave != null) {
      final fileToSave = await File(
        '$pathToSave${!RegExp(r'.json$', caseSensitive: false).hasMatch(pathToSave) ? '.json' : ''}',
      ).create();

      await fileToSave.writeAsBytes(await file.readAsBytes());
    }
  } else if (isAndroidOrIOS) {
    final directory = await getTemporaryDirectory();
    final fileToSave = await File('${directory.path}/$fileName.json').create();

    await fileToSave.writeAsBytes(await file.readAsBytes());

    await Share.shareXFiles([XFile(fileToSave.path)]);

    await fileToSave.delete();
  }
}
