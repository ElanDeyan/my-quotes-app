import 'package:flutter/material.dart';
import 'package:my_quotes/screens/main/destinations.dart';
import 'package:my_quotes/screens/main/scaffold_with_drawer.dart';

final class MainAppScreen extends StatelessWidget with DestinationsMixin {
  const MainAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const ScaffoldWithDrawer(
          destinations: DestinationsMixin.destinationsData,
        );
        // return constraints.maxWidth > constraints.maxHeight
        //     ? const ScaffoldWithDrawer(
        //         destinations: DestinationsMixin.destinationsData,
        //       )
        //     : const ScaffoldWithNavigationBar(
        //       destinations: DestinationsMixin.destinationsData,
        //     );
      },
    );
  }
}
