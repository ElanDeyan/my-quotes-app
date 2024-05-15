import 'package:flutter/material.dart';
import 'package:my_quotes/screens/main/destinations.dart';
import 'package:my_quotes/screens/main/scaffold_with_navigation_bar.dart';
import 'package:my_quotes/screens/main/scaffold_with_rail.dart';

final class MainAppScreen extends StatelessWidget with DestinationsMixin {
  const MainAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // TODO: try to fix when the screen transition 'reset' the initial index
        return constraints.maxWidth > constraints.maxHeight
            ? const ScaffoldWithRail(
                destinations: DestinationsMixin.destinationsData,
              )
            : const ScaffoldWithNavigationBar(
                destinations: DestinationsMixin.destinationsData,
              );
      },
    );
  }
}
