import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/destinations.dart';
import 'package:my_quotes/screens/home/home_screen.dart';
import 'package:my_quotes/screens/main/destinations.dart';
import 'package:my_quotes/screens/my_quotes_screen.dart';
import 'package:my_quotes/screens/search/search_quote_delegate.dart';
import 'package:my_quotes/shared/show_add_quote_dialog.dart';
import 'package:my_quotes/shared/show_quote_search.dart';

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
        1 => const MyQuotesScreen(),
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
        leading: const Icon(Icons.format_quote),
        title: const Text('My quotes'),
        shape: LinearBorder(
          bottom: const LinearBorderEdge(),
          side: BorderSide(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
        actions: [
          if (bodyContent is MyQuotesScreen) ...[
            IconButton(
              onPressed: () => showQuoteSearch(
                context,
                SearchQuoteDelegate(
                  context: context,
                  keyboardType: TextInputType.text,
                ),
              ),
              icon: const Icon(Icons.search),
            ),
            IconButton(
              icon: const Icon(Icons.label),
              tooltip: 'Tags',
              onPressed: () => context.pushNamed('tags'),
            ),
          ],
          if (isCompactWindowSize) ..._actionsForCompactWindow(context),
        ],
      ),
      body: isCompactWindowSize
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: bodyContent,
            )
          : _notCompactWindowSizeBody(context),
      floatingActionButton: isCompactWindowSize
          ? FloatingActionButton(
              tooltip: 'Add a new quote',
              onPressed: () => showAddQuoteDialog(context),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            )
          : null,
      bottomNavigationBar:
          isCompactWindowSize ? _myBottomNavigationBar() : null,
    );
  }

  List<IconButton> _actionsForCompactWindow(BuildContext context) {
    return <IconButton>[
      IconButton(
        tooltip: 'Settings',
        onPressed: () => context.pushNamed(settingsNavigationKey),
        icon: const Icon(Icons.settings),
      ),
    ];
  }

  Widget _notCompactWindowSizeBody(BuildContext context) {
    final mainDestinations = widget.destinations.values.where(
      (element) => element.debugLabel != 'settings',
    );

    final settingsDestination = widget.destinations[settingsNavigationKey]!;

    final windowSize = MediaQuery.sizeOf(context);

    final isCompactWindowSize = windowSize.width < 600;

    return SafeArea(
      child: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.selected,
            onDestinationSelected: _updateIndex,
            leading: !isCompactWindowSize
                ? FloatingActionButton(
                    tooltip: 'Add a new quote',
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    onPressed: () => showAddQuoteDialog(context),
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
            destinations: <NavigationRailDestination>[
              for (final destination in mainDestinations)
                NavigationRailDestination(
                  icon: destination.outlinedIcon,
                  label: Text(destination.label),
                  selectedIcon: destination.selectedIcon,
                ),
            ],
            trailing: IconButton(
              onPressed: () => context.pushNamed('settings'),
              icon: settingsDestination.selectedIcon,
              tooltip: settingsDestination.label,
            ),
            selectedIndex: _selectedIndex,
          ),
          const VerticalDivider(
            width: 0.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: bodyContent,
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
