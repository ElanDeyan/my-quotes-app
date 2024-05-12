import 'package:flutter/material.dart';

final class AllQuotesScreen extends StatelessWidget {
  const AllQuotesScreen({
    super.key,
  });

  static const screenName = 'All quotes';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(screenName),
    );
  }
}
