import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:my_quotes/constants/backup_file_extension.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

Future<XFile?> getBackupFile() async {
  final result = await FilePicker.platform.pickFiles(
    lockParentWindow: true,
    type: FileType.custom,
    allowedExtensions: ['txt'],
    withReadStream: true,
  );

  if (result != null) {
    final file = result.files.single;

    if (p.extension(file.name, 2) != backupFileExtension) {
      return null;
    }

    if (file.readStream case final Stream<List<int>> bytesStream) {
      final fileData = <int>[];

      await for (final data in bytesStream) {
        fileData.addAll(data);
      }

      return XFile.fromData(Uint8List.fromList(fileData));
    }
  }
  return null;
}
