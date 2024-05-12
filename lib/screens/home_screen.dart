import 'package:flutter/material.dart';

final class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  static const screenName = 'Home';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(screenName),
    );
  }
}
