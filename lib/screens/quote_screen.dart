import 'package:flutter/material.dart';

final class QuoteScreen extends StatelessWidget {
  const QuoteScreen({
    super.key,
    required this.quoteId,
  });

  final int quoteId;

  static const screenName = 'Quote';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('$screenName with $quoteId id'),
      ),
    );
  }
}
