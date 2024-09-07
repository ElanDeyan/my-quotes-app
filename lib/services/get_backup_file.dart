import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

Future<XFile?> getBackupFile() async {
  final FilePickerResult? result = await FilePicker.platform.pickFiles(
    lockParentWindow: true,
    type: FileType.custom,
    allowedExtensions: ['myquotes.txt'],
    withData: true,
  );

  if (result != null) {
    final fileBytes = result.files.single.bytes;

    if (fileBytes != null) {
      return XFile.fromData(fileBytes);
    }
  }
  return null;
}
