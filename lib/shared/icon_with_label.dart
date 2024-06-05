import 'package:flutter/material.dart';

final class IconWithLabel extends StatelessWidget {
  final Icon icon;
  final Widget label;
  final double horizontalGap;

  const IconWithLabel({
    super.key,
    required this.icon,
    required this.horizontalGap,
    required this.label,
  });
  
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
