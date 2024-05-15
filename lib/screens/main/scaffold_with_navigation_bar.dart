import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/destinations.dart';
import 'package:my_quotes/screens/all_quotes_screen.dart';
import 'package:my_quotes/screens/home_screen.dart';

final class ScaffoldWithNavigationBar extends StatefulWidget {
  const ScaffoldWithNavigationBar({super.key, required this.destinations});

  final Map<String, DestinationData> destinations;

  @override
  State<ScaffoldWithNavigationBar> createState() =>
      _ScaffoldWithNavigationBarState();
}

final class _ScaffoldWithNavigationBarState
    extends State<ScaffoldWithNavigationBar> {
  int _selectedIndex = 0;

  Widget get bodyContent => switch (_selectedIndex) {
        0 => const HomeScreen(),
        1 => const AllQuotesScreen(),
        _ => throw UnimplementedError(),
      };

  void _updateIndex(int value) => setState(() {
        _selectedIndex = value;
      });

  @override
  Widget build(BuildContext context) {
    final mainDestinations = widget.destinations.values.where(
      (element) => element.debugLabel != 'settings',
    );

    final settingsDestination = widget.destinations[settingsNavigationKey]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Quotes'),
        actions: <IconButton>[
          IconButton(
            onPressed: () => context.goNamed('settings'),
            icon: settingsDestination.selectedIcon,
            tooltip: settingsDestination.label,
          ),
        ],
      ),
      body: bodyContent,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _updateIndex,
        destinations: <NavigationDestination>[
          for (final destination in mainDestinations)
            NavigationDestination(
              icon: destination.outlinedIcon,
              label: destination.label,
              selectedIcon: destination.selectedIcon,
              tooltip: destination.label,
            ),
        ],
      ),
    );
  }
}
