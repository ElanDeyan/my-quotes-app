import 'package:flutter/material.dart';
import 'package:my_quotes/screens/home/random_quote_container.dart';

final class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  static const screenName = 'Home';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: <Widget>[
          Spacer(),
          RandomQuoteContainer(),
          Spacer(),
          Placeholder(
            child: Text('Favorites history'),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
