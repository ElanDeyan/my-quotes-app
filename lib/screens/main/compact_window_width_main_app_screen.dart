import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/destinations.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/main/destinations.dart';
import 'package:my_quotes/screens/main/main_app_screen_app_bar.dart';
import 'package:my_quotes/screens/main/main_app_screen_mixin.dart';
import 'package:my_quotes/screens/my_quotes/my_quotes_screen.dart';
import 'package:my_quotes/screens/search/search_quote_delegate.dart';
import 'package:my_quotes/shared/actions/quotes/show_quote_search.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';

class CompactWindowWidthMainAppScreen extends StatefulWidget {
  const CompactWindowWidthMainAppScreen({
    required this.initialIndex,
    super.key,
  });

  final int initialIndex;

  @override
  State<CompactWindowWidthMainAppScreen> createState() =>
      _CompactWindowWidthMainAppScreenState();
}

class _CompactWindowWidthMainAppScreenState
    extends State<CompactWindowWidthMainAppScreen> with MainAppScreenMixin {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _updatePage(int index) => setState(() {
        _selectedIndex = index;
      });

  @override
  Widget build(BuildContext context) {
    final mainDestinations =
        DestinationsMixin.destinationsDataOf(context.appLocalizations)
            .values
            .where(
              (element) => element.debugLabel != 'settings',
            )
            .toList();

    final settingsDestination = DestinationsMixin.destinationsDataOf(
      context.appLocalizations,
    )[settingsNavigationKey]!;

    return Scaffold(
      appBar: MainAppScreenAppBar(
        actions: _actions(settingsDestination, context),
      ),
      body: RepaintBoundary(
        child: AnimatedSwitcher(
          duration: Durations.short4,
          child: screens[_selectedIndex],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(addQuoteNavigationKey),
        label: Text(context.appLocalizations.addQuoteTitle),
        icon: const Icon(Icons.add_outlined),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _updatePage,
        destinations: List.generate(
          mainDestinations.length,
          (index) {
            final destination = mainDestinations[index];
            return NavigationDestination(
              icon: destination.outlinedIcon,
              selectedIcon: destination.selectedIcon,
              tooltip: destination.label,
              label: destination.label,
            );
          },
          growable: false,
        ),
      ),
    );
  }

  List<Widget> _actions(
    DestinationData settingsDestination,
    BuildContext context,
  ) {
    return [
      if (screens[_selectedIndex] is MyQuotesScreen) ...[
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
      IconButton(
        tooltip: settingsDestination.label,
        onPressed: () => context.pushNamed(settingsNavigationKey),
        icon: settingsDestination.outlinedIcon,
      ),
    ];
  }
}
