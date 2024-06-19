import 'package:flutter/material.dart';

class PillChip extends Chip {
  PillChip({super.key, required super.label})
      : super(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
          ),
        );

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: label,
      shape: shape,
    );
  }
}
