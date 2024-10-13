import 'package:flutter/material.dart';

class PillChip extends Chip {
  PillChip({required super.label, super.key})
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
