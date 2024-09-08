import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/main/destinations.dart';
import 'package:my_quotes/screens/main/main_app_screen_app_bar.dart';
import 'package:my_quotes/screens/main/main_app_screen_mixin.dart';
import 'package:my_quotes/screens/my_quotes/my_quotes_screen.dart';
import 'package:my_quotes/screens/search/search_quote_delegate.dart';
import 'package:my_quotes/shared/actions/quotes/show_quote_search.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';

class LargeWindowWidthMainAppScreen extends StatefulWidget {
  const LargeWindowWidthMainAppScreen({
    super.key,
    required this.initialIndex,
  });

  final int initialIndex;

  @override
  State<LargeWindowWidthMainAppScreen> createState() =>
      _LargeWindowWidthMainAppScreenState();
}

class _LargeWindowWidthMainAppScreenState
    extends State<LargeWindowWidthMainAppScreen> with MainAppScreenMixin {
  late int _selectedIndex;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _updateIndex(int value) => setState(() {
        _selectedIndex = value;
      });

  @override
  Widget build(BuildContext context) {
    final destinations =
        DestinationsMixin.destinationsDataOf(context.appLocalizations);

    final mainDestinations = [
      for (final destination in destinations.values)
        if (destination.debugLabel != settingsNavigationKey) destination,
    ];
    final settingsDestination = destinations[settingsNavigationKey]!;
    return Scaffold(
      appBar: MainAppScreenAppBar(
        shape: LinearBorder.bottom(
          side: BorderSide(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
        actions: _appBarActions(context),
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              destinations: List.generate(
                mainDestinations.length,
                (index) {
                  final destination = mainDestinations[index];
                  return NavigationRailDestination(
                    icon: destination.outlinedIcon,
                    selectedIcon: destination.selectedIcon,
                    label: Text(destination.label),
                  );
                },
              ),
              selectedIndex: _selectedIndex,
              onDestinationSelected: _updateIndex,
              labelType: NavigationRailLabelType.all,
              leading: FloatingActionButton(
                onPressed: () => context.pushNamed(addQuoteNavigationKey),
                child: const Icon(Icons.add_outlined),
              ),
              trailing: IconButton(
                onPressed: () => context.pushNamed(settingsNavigationKey),
                icon: settingsDestination.outlinedIcon,
                tooltip: settingsDestination.label,
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: RepaintBoundary(
                child: AnimatedSwitcher(
                  duration: Durations.short4,
                  child: getBodyFrom(_selectedIndex),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _appBarActions(BuildContext context) {
    return <Widget>[
      if (getBodyFrom(_selectedIndex) is MyQuotesScreen) ...<Widget>[
        IconButton(
          tooltip: context.appLocalizations.navigationSearchQuote,
          onPressed: () => showQuoteSearch(
            context,
            SearchQuoteDelegate(
              context: context,
              keyboardType: TextInputType.text,
              searchFieldLabel: context.appLocalizations.navigationSearchLabel,
            ),
          ),
          icon: const Icon(Icons.search_outlined),
        ),
        IconButton(
          icon: const Icon(Icons.label_outlined),
          tooltip: context.appLocalizations.navigationTags,
          onPressed: () => context.pushNamed(tagsNavigationKey),
        ),
      ],
      IconButton(
        icon: const Icon(Icons.upload_file_outlined),
        tooltip: context.appLocalizations.addFromFile,
        onPressed: () => onUploadQuoteFile(context),
      ),
      PopupMenuButton<void>(
        itemBuilder: (context) => [
          PopupMenuItem(
            onTap: () => onGenerateBackupFile(context),
            child: IconWithLabel(
              icon: const Icon(Icons.backup_outlined),
              horizontalGap: 10,
              label: Text(context.appLocalizations.createBackup),
            ),
          ),
          PopupMenuItem(
            child: IconWithLabel(
              icon: const Icon(Icons.settings_backup_restore_outlined),
              horizontalGap: 10,
              label: Text(context.appLocalizations.restoreBackup),
            ),
            onTap: () => onRestoreBackupFile(context),
          ),
        ],
        icon: const Icon(Icons.import_export_outlined),
        tooltip: context.appLocalizations.backupOptionsTooltip,
      ),
    ];
  }
}
