import 'package:flutter/material.dart';

class QuotesSliverListViewBottomSpacing extends StatelessWidget {
  const QuotesSliverListViewBottomSpacing({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: SizedBox(
        height: kBottomNavigationBarHeight + (2 * kFloatingActionButtonMargin),
      ),
    );
  }
}
