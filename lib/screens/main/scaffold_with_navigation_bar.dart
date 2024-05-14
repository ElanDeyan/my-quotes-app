import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/destinations.dart';

class ScaffoldWithNavigationBar extends StatefulWidget {
  const ScaffoldWithNavigationBar({super.key, required this.destinations});

  final Map<String, DestinationData> destinations;

  @override
  State<ScaffoldWithNavigationBar> createState() =>
      _ScaffoldWithNavigationBarState();
}

class _ScaffoldWithNavigationBarState extends State<ScaffoldWithNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <IconButton>[
          IconButton(
            onPressed: () => context.goNamed('settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const Placeholder(),
      bottomNavigationBar: const Placeholder(),
    );
  }
}
