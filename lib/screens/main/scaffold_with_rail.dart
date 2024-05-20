import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/destinations.dart';
import 'package:my_quotes/screens/all_quotes_screen.dart';
import 'package:my_quotes/screens/home_screen.dart';

final class ScaffoldWithRail extends StatefulWidget {
  const ScaffoldWithRail({super.key, required this.destinations});

  final Map<String, DestinationData> destinations;

  @override
  State<ScaffoldWithRail> createState() => _ScaffoldWithRailState();
}

final class _ScaffoldWithRailState extends State<ScaffoldWithRail> {
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
        title: const Text('My quotes'),
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              labelType: NavigationRailLabelType.selected,
              onDestinationSelected: _updateIndex,
              destinations: <NavigationRailDestination>[
                for (final destination in mainDestinations)
                  NavigationRailDestination(
                    icon: destination.outlinedIcon,
                    label: Text(destination.label),
                    selectedIcon: destination.selectedIcon,
                  ),
              ],
              trailing: IconButton(
                onPressed: () => context.goNamed('settings'),
                icon: settingsDestination.selectedIcon,
                tooltip: settingsDestination.label,
              ),
              selectedIndex: _selectedIndex,
            ),
            const VerticalDivider(),
            Expanded(child: bodyContent),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed('add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
