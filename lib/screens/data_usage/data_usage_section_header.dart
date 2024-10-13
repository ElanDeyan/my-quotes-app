import 'package:flutter/material.dart';

class DataUsageSectionHeader extends StatelessWidget {
  const DataUsageSectionHeader({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
