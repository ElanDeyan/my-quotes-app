import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/enums/parse_quote_file_errors.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/repository/interfaces/app_repository.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/home/home_screen.dart';
import 'package:my_quotes/screens/main/destinations.dart';
import 'package:my_quotes/screens/main/main_app_screen_app_bar.dart';
import 'package:my_quotes/screens/my_quotes/my_quotes_screen.dart';
import 'package:my_quotes/screens/search/search_quote_delegate.dart';
import 'package:my_quotes/services/file_picker.dart';
import 'package:my_quotes/services/generate_backup_file.dart';
import 'package:my_quotes/services/handle_backup_file.dart';
import 'package:my_quotes/services/handle_quote_file.dart';
import 'package:my_quotes/services/save_file.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/shared/actions/quotes/show_add_quote_from_file_dialog.dart';
import 'package:my_quotes/shared/actions/quotes/show_quote_search.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';

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
    extends State<LargeWindowWidthMainAppScreen> {
  late int _selectedIndex;
  late final HomeScreen _homeScreen;
  late final MyQuotesScreen _myQuotesScreen;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _homeScreen = const HomeScreen(
      key: Key('home_screen'),
    );
    _myQuotesScreen = const MyQuotesScreen(
      key: Key('my_quotes_screen'),
    );
  }

  Widget get body => switch (_selectedIndex) {
        0 => _homeScreen,
        1 => _myQuotesScreen,
        _ => throw UnimplementedError(),
      };

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
                  child: body,
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
      if (body is MyQuotesScreen) ...<Widget>[
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
        onPressed: () => _handleQuoteFile(context),
      ),
      PopupMenuButton<void>(
        itemBuilder: (context) => [
          PopupMenuItem(
            onTap: () => _handleGenerateBackupFile(context),
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
            onTap: () async {
              final backupFile = await getJsonFile();

              if (context.mounted) {
                await handleBackupFile(context, backupFile);
              }
            },
          ),
        ],
        icon: const Icon(Icons.import_export_outlined),
        tooltip: context.appLocalizations.backupOptionsTooltip,
      ),
    ];
  }

  Future<void> _handleGenerateBackupFile(BuildContext context) async {
    final appPreferences = Provider.of<AppPreferences>(context, listen: false);

    final backupFile = await generateBackupFile(
      serviceLocator<AppRepository>(),
      appPreferences,
    );

    await saveJsonFile(backupFile);
  }

  Future<void> _handleQuoteFile(BuildContext context) async {
    final result = await handleQuoteFile();
    if (result.data != null) {
      if (context.mounted) {
        await showAddQuoteFromFileDialog(
          context,
          result.data!.quote,
          result.data!.tags,
        );
      }
    } else if (result.error != null) {
      if (context.mounted) {
        showToast(
          context,
          child: PillChip(
            label: Text(
              ParseQuoteFileErrors.localizedErrorMessageOf(
                context,
                result.error!,
              ),
            ),
          ),
        );
      }
    }
  }
}
