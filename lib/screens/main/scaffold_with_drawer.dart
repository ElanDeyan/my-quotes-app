import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/destinations.dart';
import 'package:my_quotes/screens/all_quotes_screen.dart';
import 'package:my_quotes/screens/home_screen.dart';

final class ScaffoldWithDrawer extends StatefulWidget {
  const ScaffoldWithDrawer({super.key, required this.destinations});

  final Map<String, DestinationData> destinations;

  @override
  State<ScaffoldWithDrawer> createState() => _ScaffoldWithDrawerState();
}

final class _ScaffoldWithDrawerState extends State<ScaffoldWithDrawer> {
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
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: [
                    for (final destination in mainDestinations)
                      ListTile(
                        leading: destination.selectedIcon,
                        title: Text(destination.label),
                        selected: destination.index == _selectedIndex,
                        onTap: () => _updateIndex(destination.index),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              ListTile(
                leading: settingsDestination.selectedIcon,
                title: Text(settingsDestination.label),
                onTap: () => context.goNamed('settings'),
              ),
            ],
          ),
        ),
      ),
      body: bodyContent,
    );
  }
}
