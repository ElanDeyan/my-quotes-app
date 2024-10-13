import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/repository/secure_repository.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/settings/allow_error_reporting_tile.dart';
import 'package:my_quotes/screens/settings/app_info_tile.dart';
import 'package:my_quotes/screens/settings/choose_app_language_tile.dart';
import 'package:my_quotes/screens/settings/choose_color_scheme_palette_tile.dart';
import 'package:my_quotes/screens/settings/choose_theme_mode_tile.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  Future<void> _handleUserFeedback(BuildContext context) async {
    if (await serviceLocator<SecureRepository>().allowErrorReporting) {
      if (context.mounted) {
        BetterFeedback.of(context).showAndUploadToSentry();
      }
    } else {
      // TODO(elan): Maybe use a form to the user answer some questions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.canPop()
              ? context.pop(context)
              : context.pushNamed(homeNavigationKey),
        ),
        title: Text(context.appLocalizations.settings),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleUserFeedback(context),
        label: IconWithLabel(
          icon: const Icon(Icons.feedback_outlined),
          horizontalGap: 10,
          label: Text(context.appLocalizations.feedbackButtonLabel),
        ),
      ),
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              context.appLocalizations.userPreferences,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(),
          const ChooseThemeModeTile(),
          const ChooseColorSchemePaletteTile(),
          const ChooseAppLanguageTile(),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              context.appLocalizations.yourPrivacy,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(),
          const AllowErrorReportingTile(),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              context.appLocalizations.about,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(),
          const AppInfoTile(),
        ],
      ),
    );
  }
}
