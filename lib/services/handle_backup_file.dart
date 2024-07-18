import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/helpers/string_to_color_pallete.dart';
import 'package:my_quotes/helpers/string_to_theme_mode.dart';
import 'package:my_quotes/repository/user_preferences_interfaces.dart';
import 'package:my_quotes/services/parse_backup_file.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> handleBackupFile(BuildContext context, XFile? file) async {
  if (file != null) {
    final backupData = await (kIsWeb
        ? parseBackupFile(file)
        : Isolate.run(() => parseBackupFile(file)));

    if (backupData != null) {
      if (context.mounted) {
        final wantsToImport = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            actions: [
              TextButton.icon(
                onPressed: () => Navigator.pop(context, false),
                label: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pop(context, true),
                label: Text(AppLocalizations.of(context)!.restoreData),
              ),
            ],
            icon: const Icon(Icons.backup_outlined),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.restoreQuestion),
                Text(
                  AppLocalizations.of(context)!.restoreAdvice,
                ),
              ],
            ),
          ),
        );

        if (wantsToImport ?? false) {
          if (context.mounted) {
            final preferences =
                Provider.of<AppPreferences>(context, listen: false);

            final (:colorPalette, :language, :themeMode) =
                backupData.userPreferencesData;

            preferences
              ..colorSchemePalette =
                  ColorSchemePaletteExtension.colorSchemePaletteFromString(
                        colorPalette,
                      ) ??
                      ColorSchemePaletteRepository.defaultColorSchemePalette
              ..themeMode = ThemeModeExtension.themeModeFromString(themeMode) ??
                  ThemeModeRepository.defaultThemeMode
              ..language = language;

            final database =
                Provider.of<DatabaseProvider>(context, listen: false);

            final (quotes, tags) = (backupData.quotes, backupData.tags);

            await database.restoreData(tags, quotes);
          }
        }
      }
    } else {
      if (context.mounted) {
        showToast(
          context,
          child: PillChip(
            label: Text(AppLocalizations.of(context)!.backupFileParseError),
          ),
        );
      }
    }
  }
}
