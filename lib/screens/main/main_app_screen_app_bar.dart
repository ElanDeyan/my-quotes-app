import 'package:flutter/material.dart';

class MainAppScreenAppBar extends AppBar {
  MainAppScreenAppBar({
    super.key,
    super.actions,
    super.shape,
  }) : super(
          leading: const Icon(Icons.format_quote_outlined),
          title: const Text('My Quotes'),
        );
}
