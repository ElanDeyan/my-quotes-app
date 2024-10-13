import 'package:flutter/material.dart';

final class IconWithLabel extends StatelessWidget {
  const IconWithLabel({
    required this.icon,
    required this.horizontalGap,
    required this.label,
    super.key,
  });
  final Widget icon;
  final Widget label;
  final double horizontalGap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        SizedBox(width: horizontalGap),
        label,
      ],
    );
  }
}
