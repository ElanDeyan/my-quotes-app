import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/destinations.dart';
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
import 'package:my_quotes/shared/actions/quotes/show_add_quote_from_file_dialog.dart';
import 'package:my_quotes/shared/actions/quotes/show_quote_search.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:provider/provider.dart';

class CompactWindowWidthMainAppScreen extends StatefulWidget {
  const CompactWindowWidthMainAppScreen({
    super.key,
    required this.initialIndex,
  });

  final int initialIndex;

  @override
  State<CompactWindowWidthMainAppScreen> createState() =>
      _CompactWindowWidthMainAppScreenState();
}

class _CompactWindowWidthMainAppScreenState
    extends State<CompactWindowWidthMainAppScreen> {
  late int _selectedIndex;
  late HomeScreen _homeScreen;
  late MyQuotesScreen _myQuotesScreen;

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
        child: AnimatedSwitcher(duration: Durations.short4, child: body),
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

  List<Widget> _actions(
    DestinationData settingsDestination,
    BuildContext context,
  ) {
    return [
      if (body is MyQuotesScreen) ...[
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
      IconButton(
        tooltip: settingsDestination.label,
        onPressed: () => context.pushNamed(settingsNavigationKey),
        icon: settingsDestination.outlinedIcon,
      ),
    ];
  }
}
