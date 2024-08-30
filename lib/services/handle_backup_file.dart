import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/string_to_color_pallete.dart';
import 'package:my_quotes/helpers/string_to_theme_mode.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/repository/user_preferences_interfaces.dart';
import 'package:my_quotes/services/parse_backup_file.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/actions/show_wants_to_import_dialog.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:my_quotes/states/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> handleBackupFile(BuildContext context, XFile? file) async {
  if (file != null) {
    final backupData = await compute(parseBackupFile, file);

    if (backupData != null) {
      if (context.mounted) {
        final wantsToImport = await showWantsToImportDialog(context);

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

            final (quotes, tags) = (backupData.quotes, backupData.tags);

            await serviceLocator<AppRepository>().restoreData(tags, quotes);
          }
        }
      }
    } else {
      if (context.mounted) {
        showToast(
          context,
          child: PillChip(
            label: Text(context.appLocalizations.backupFileParseError),
          ),
        );
      }
    }
  }
}
