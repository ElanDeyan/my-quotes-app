import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:my_quotes/helpers/nullable_extension.dart';

Future<File?> getQuoteFile() async {
  final FilePickerResult? result = await FilePicker.platform.pickFiles(
    lockParentWindow: true,
    type: FileType.custom,
    allowedExtensions: ['json'],
  );

  if (result.isNotNull) {
    return File(result!.files.single.path!);
  }
  return null;
}
