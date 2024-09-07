import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:my_quotes/constants/platforms.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<bool> saveBackupFile(XFile backupFile) async {
  final fileName =
      'My-Quotes-Backup-File-${DateTime.now().millisecondsSinceEpoch}.myquotes.txt';

  if (isAndroidOrIOS) {
    final directory = await getTemporaryDirectory();
    final fileToSave = await File('${directory.path}/$fileName').create();

    await fileToSave.writeAsBytes(await backupFile.readAsBytes());

    final result = await Share.shareXFiles([XFile(fileToSave.path)]);

    try {
      return result.status == ShareResultStatus.success;
    } finally {
      await fileToSave.delete();
    }
  } else if (isDesktop) {
    final pathToSave = await FilePicker.platform.saveFile(
      type: FileType.custom,
      allowedExtensions: ['myquotes.txt'],
      lockParentWindow: true,
    );

    if (pathToSave != null) {
      final endsWithBackupFileExtension =
          p.extension(pathToSave, 2) == '.myquotes.txt';
      final file = await File(
        '$pathToSave${!endsWithBackupFileExtension ? '.myquotes.txt' : ''}',
      ).create();
      await file.writeAsBytes(
        await backupFile.readAsBytes(),
      );

      return true;
    }

    return false;
  } else {
    await FileSaver.instance.saveFile(
      name: fileName,
      bytes: await backupFile.readAsBytes(),
      mimeType: MimeType.text,
    );

    return true;
  }
}
