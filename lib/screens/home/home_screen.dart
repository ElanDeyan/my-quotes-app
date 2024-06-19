import 'package:flutter/material.dart';
import 'package:my_quotes/screens/home/random_quote_container.dart';

final class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(
        child: RandomQuoteContainer(),
      ),
    );
  }
}
