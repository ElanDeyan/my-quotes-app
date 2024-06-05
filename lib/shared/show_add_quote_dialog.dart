import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_quotes/screens/add_quote_screen.dart';

Future<void> showAddQuoteDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => const Dialog.fullscreen(child: AddQuoteScreen()),
  );
}
