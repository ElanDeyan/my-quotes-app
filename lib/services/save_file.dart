import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:my_quotes/constants/platforms.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> saveJsonFile(XFile backupFile) async {
  final fileName =
      'My-Quotes-Backup-File-${DateTime.now().millisecondsSinceEpoch}.json';

  if (isAndroidOrIOS) {
    final directory = await getTemporaryDirectory();
    final fileToSave = await File('${directory.path}/$fileName').create();

    await fileToSave.writeAsBytes(await backupFile.readAsBytes());

    await Share.shareXFiles([XFile(fileToSave.path)]);

    await fileToSave.delete();
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
        await backupFile.readAsBytes(),
      );
    }
  } else {
    await FileSaver.instance.saveFile(
      name: fileName,
      bytes: await backupFile.readAsBytes(),
      mimeType: MimeType.json,
    );
  }
}
