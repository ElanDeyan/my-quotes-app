import 'package:flutter/widgets.dart';
import 'package:my_quotes/constants/enums/parse_quote_file_errors.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/repository/secure_repository.dart';
import 'package:my_quotes/screens/home/home_screen.dart';
import 'package:my_quotes/screens/my_quotes/my_quotes_screen.dart';
import 'package:my_quotes/services/generate_backup_file.dart';
import 'package:my_quotes/services/get_backup_file.dart';
import 'package:my_quotes/services/handle_backup_file.dart';
import 'package:my_quotes/services/handle_quote_file.dart';
import 'package:my_quotes/services/save_backup_file.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/shared/actions/quotes/show_add_quote_from_file_dialog.dart';
import 'package:my_quotes/shared/actions/show_create_password_dialog.dart';
import 'package:my_quotes/shared/actions/show_enter_password_dialog.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';

mixin MainAppScreenMixin {
  final screens = [
    const HomeScreen(
      key: Key('home_screen'),
    ),
    const MyQuotesScreen(
      key: Key('my_quotes_screen'),
    ),
  ];

  Future<void> onGenerateBackupFile(BuildContext context) async {
    final appPreferences = Provider.of<AppPreferences>(context, listen: false);

    final userPassword = await showCreatePasswordDialog(context);

    if (userPassword != null) {
      final backupFile = await generateBackupFile(
        serviceLocator<AppRepository>(),
        appPreferences,
        serviceLocator<SecureRepository>(),
        userPassword,
      );

      final result = await saveBackupFile(backupFile);

      if (result && context.mounted) {
        showToast(
          context,
          child: PillChip(
            label: Text(context.appLocalizations.successfulOperation),
          ),
        );
      }
    }
  }

  Future<void> onRestoreBackupFile(BuildContext context) async {
    final backupFile = await getBackupFile();

    if (backupFile != null && context.mounted) {
      final userPassword = await showEnterPasswordDialog(context);

      if (userPassword != null && context.mounted) {
        await handleBackupFile(context, backupFile, userPassword);
      }
    }
  }

  Future<void> onUploadQuoteFile(BuildContext context) async {
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
