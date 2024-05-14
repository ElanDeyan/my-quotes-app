import 'package:flutter/material.dart';

enum ColorPallete {
  blue(Colors.blue),
  red(Colors.red),
  amber(Colors.amber);

  const ColorPallete(this.color);

  final Color color;
}
