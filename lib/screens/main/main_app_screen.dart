import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/destinations.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/home/home_screen.dart';
import 'package:my_quotes/screens/main/destinations.dart';
import 'package:my_quotes/screens/my_quotes_screen.dart';
import 'package:my_quotes/screens/search/search_quote_delegate.dart';
import 'package:my_quotes/services/file_picker.dart';
import 'package:my_quotes/services/generate_backup_file.dart';
import 'package:my_quotes/services/handle_backup_file.dart';
import 'package:my_quotes/services/handle_quote_file.dart';
import 'package:my_quotes/services/save_file.dart';
import 'package:my_quotes/shared/actions/quotes/show_add_quote_dialog.dart';
import 'package:my_quotes/shared/actions/quotes/show_quote_search.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';

final class MainAppScreen extends StatefulWidget with DestinationsMixin {
  const MainAppScreen({
    super.key,
    required this.destinations,
    this.initialLocationIndex = 0,
  });

  final Map<String, DestinationData> destinations;
  final int initialLocationIndex;

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

final class _MainAppScreenState extends State<MainAppScreen> {
  late int _selectedIndex;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialLocationIndex;
  }

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
        actions: _appBarActions(context, isCompactWindowSize),
      ),
      body: isCompactWindowSize
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: bodyContent,
            )
          : _notCompactWindowSizeBody(context),
      floatingActionButton: isCompactWindowSize
          ? FloatingActionButton(
              tooltip: AppLocalizations.of(context)!.navigationAddQuote,
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

  List<Widget> _appBarActions(BuildContext context, bool isCompactWindowSize) {
    return <Widget>[
      if (bodyContent is MyQuotesScreen) ...<Widget>[
        IconButton(
          tooltip: AppLocalizations.of(context)!.navigationSearchQuote,
          onPressed: () => showQuoteSearch(
            context,
            SearchQuoteDelegate(
              context: context,
              keyboardType: TextInputType.text,
              searchFieldLabel:
                  AppLocalizations.of(context)!.navigationSearchLabel,
            ),
          ),
          icon: const Icon(Icons.search_outlined),
        ),
        IconButton(
          icon: const Icon(Icons.label_outlined),
          tooltip: AppLocalizations.of(context)!.navigationTags,
          onPressed: () => context.pushNamed(tagsNavigationKey),
        ),
      ],
      IconButton(
        icon: const Icon(Icons.upload_file_outlined),
        tooltip: AppLocalizations.of(context)!.addFromFile,
        onPressed: () async => await handleQuoteFile(context),
      ),
      PopupMenuButton<void>(
        itemBuilder: (context) => [
          PopupMenuItem(
            child: IconWithLabel(
              icon: const Icon(Icons.backup_outlined),
              horizontalGap: 10,
              label: Text(AppLocalizations.of(context)!.createBackup),
            ),
            onTap: () async {
              final backupFile = await generateBackupFile(context);
              if (backupFile != null) {
                await saveJsonFile(
                  backupFile,
                  'MyQuotes-Backup-${DateTime.now()}',
                );
              }
            },
          ),
          PopupMenuItem(
            child: IconWithLabel(
              icon: const Icon(Icons.settings_backup_restore_outlined),
              horizontalGap: 10,
              label: Text(AppLocalizations.of(context)!.restoreBackup),
            ),
            onTap: () async {
              final backupFile = await getJsonFile();

              if (context.mounted) {
                await handleBackupFile(context, backupFile);
              }
            },
          ),
        ],
        icon: const Icon(Icons.import_export_outlined),
        tooltip: AppLocalizations.of(context)!.backupOptionsTooltip,
      ),
      if (isCompactWindowSize) ..._actionsForCompactWindow(context),
    ];
  }

  List<IconButton> _actionsForCompactWindow(BuildContext context) {
    final settingsDestination = widget.destinations[settingsNavigationKey]!;
    return <IconButton>[
      IconButton(
        tooltip: settingsDestination.label,
        onPressed: () => context.pushNamed(settingsNavigationKey),
        icon: settingsDestination.outlinedIcon,
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
                    tooltip: AppLocalizations.of(context)!.navigationAddQuote,
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
              onPressed: () => context.pushNamed(settingsNavigationKey),
              icon: settingsDestination.outlinedIcon,
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
