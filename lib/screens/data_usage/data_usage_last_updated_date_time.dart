import 'package:flutter/material.dart';

class DataUsageLastUpdatedDateTime extends StatelessWidget {
  const DataUsageLastUpdatedDateTime({
    required this.lastUpdatedDateTime,
    super.key,
  });

  final DateTime lastUpdatedDateTime;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Last updated: ${lastUpdatedDateTime.year}'
      '-${lastUpdatedDateTime.month}-${lastUpdatedDateTime.day}',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
