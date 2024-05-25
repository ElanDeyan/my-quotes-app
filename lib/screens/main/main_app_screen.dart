import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/destinations.dart';
import 'package:my_quotes/screens/all_quotes_screen.dart';
import 'package:my_quotes/screens/home/home_screen.dart';
import 'package:my_quotes/screens/main/destinations.dart';

final class MainAppScreen extends StatefulWidget with DestinationsMixin {
  const MainAppScreen({super.key, required this.destinations});

  final Map<String, DestinationData> destinations;

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

final class _MainAppScreenState extends State<MainAppScreen> {
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
    final windowSize = MediaQuery.sizeOf(context);

    final isCompactWindowSize = windowSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My quotes'),
        actions: isCompactWindowSize ? _actionsForCompactWindow(context) : null,
      ),
      body: isCompactWindowSize
          ? ColoredBox(
              color: _primaryContainerOf(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: bodyContent,
              ),
            )
          : _notCompactWindowSizeBody(context),
      bottomNavigationBar:
          isCompactWindowSize ? _myBottomNavigationBar() : null,
    );
  }

  Color _primaryContainerOf(BuildContext context) =>
      Theme.of(context).colorScheme.primaryContainer;

  List<IconButton> _actionsForCompactWindow(BuildContext context) {
    return <IconButton>[
      IconButton(
        onPressed: () => context.goNamed(settingsNavigationKey),
        icon: const Icon(Icons.settings),
      ),
    ];
  }

  Widget _notCompactWindowSizeBody(BuildContext context) {
    final mainDestinations = widget.destinations.values.where(
      (element) => element.debugLabel != 'settings',
    );

    final settingsDestination = widget.destinations[settingsNavigationKey]!;

    return SafeArea(
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
          const VerticalDivider(
            width: 0.0,
          ),
          Expanded(
            child: ColoredBox(
              color: _primaryContainerOf(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: bodyContent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  NavigationBar _myBottomNavigationBar() {
    final mainDestinations = widget.destinations.values.where(
      (element) => element.debugLabel != 'settings',
    );

    return NavigationBar(
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
    );
  }
}
