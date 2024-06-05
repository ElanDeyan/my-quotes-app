import 'package:flutter/services.dart';

Future<void> copyToClipBoard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}
