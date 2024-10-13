import 'package:flutter/widgets.dart';
import 'package:my_quotes/screens/main/compact_window_width_main_app_screen.dart';
import 'package:my_quotes/screens/main/large_window_width_main_app_screen.dart';

class MainAppScreen extends StatelessWidget {
  const MainAppScreen({required this.initialIndex, super.key});

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
