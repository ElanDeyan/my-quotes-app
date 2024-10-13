import 'package:flutter/material.dart';

class DataUsageVersion extends StatelessWidget {
  const DataUsageVersion({
    required this.version,
    super.key,
  });

  final String version;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Version: $version',
      style: Theme.of(context).textTheme.labelMedium,
    );
  }
}
