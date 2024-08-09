import 'package:flutter/material.dart';

extension StringExtension on String {
  String toTitleCase() => (StringBuffer()
        ..writeAll(
          [this[0].toUpperCase(), characters.getRange(1).toLowerCase()],
        ))
      .toString();
}
