import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> copyToClipBoard(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text)).then(
    (value) => FToast().init(context).showToast(
          child: Chip(
            label: const Text('Copied to clipboard!'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
  );
}
