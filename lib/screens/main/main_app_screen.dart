import 'package:flutter/widgets.dart';
import 'package:my_quotes/screens/main/compact_window_width_main_app_screen.dart';
import 'package:my_quotes/screens/main/destinations.dart';
import 'package:my_quotes/screens/main/large_window_width_main_app_screen.dart';

class MainAppScreen extends StatelessWidget with DestinationsMixin {
  const MainAppScreen({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.sizeOf(context).width;

    return switch (windowWidth) {
      < 600 => CompactWindowWidthMainAppScreen(
          initialIndex: initialIndex,
        ),
      _ => LargeWindowWidthMainAppScreen(
          initialIndex: initialIndex,
        ),
    };
  }
}
