import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

Future<XFile?> getBackupFile() async {
  final FilePickerResult? result = await FilePicker.platform.pickFiles(
    lockParentWindow: true,
    type: FileType.custom,
    allowedExtensions: ['txt'],
    withData: true,
  );

  if (result != null) {
    final file = result.files.single;

    if (p.extension(file.name, 2) != '.myquotes.txt') {
      return null;
    }

    if (file.bytes != null) {
      return XFile.fromData(file.bytes!);
    }
  }
  return null;
}
