import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/enums/color_scheme_palette.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/string_extension.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/settings/choose_app_language_dialog.dart';
import 'package:my_quotes/screens/settings/choose_color_scheme_palette_dialog.dart';
import 'package:my_quotes/screens/settings/choose_theme_mode_dialog.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

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
        onPressed: () => BetterFeedback.of(context).showAndUploadToSentry(),
        label: IconWithLabel(
          icon: const Icon(Icons.feedback_outlined),
          horizontalGap: 10,
          label: Text(context.appLocalizations.feedbackButtonLabel),
        ),
      ),
      body: Consumer<AppPreferences>(
        builder: (context, appPreferences, child) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.brightness_medium_outlined),
              title: Text(context.appLocalizations.themeMode),
              subtitle: Text(
                context.appLocalizations
                    .themeModeName(appPreferences.themeMode.name)
                    .toTitleCase(),
              ),
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => const ChooseThemeModeDialog(
                  key: Key('choose_theme_mode_dialog'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: Text(context.appLocalizations.colorPallete),
              subtitle: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: ColorSchemePalette.primaryColor(
                      appPreferences.colorSchemePalette,
                      MediaQuery.platformBrightnessOf(context),
                    ),
                    minRadius: 5.0,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    context.appLocalizations.colorPaletteName(
                      appPreferences.colorSchemePalette.storageName,
                    ),
                  ),
                ],
              ),
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => const ChooseColorSchemePaletteDialog(
                  key: Key('choose_color_scheme_palette_dialog'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.translate_outlined),
              title: Text(context.appLocalizations.language),
              subtitle: Text(
                context.appLocalizations.languageName(appPreferences.language),
              ),
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => const ChooseAppLanguageDialog(
                  key: Key('choose_app_language_dialog'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(context.appLocalizations.info),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'My Quotes',
                applicationVersion: '0.1.0',
                applicationIcon: const Icon(Icons.format_quote),
                children: [
                  Text(context.appLocalizations.infoDescription),
                  Wrap(
                    spacing: 5.0,
                    children: <IconButton>[
                      IconButton(
                        onPressed: () async => await launchUrl(
                          Uri.parse(
                            'https://www.linkedin.com/in/elan-almeida-a3391225b/',
                          ),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.linkedinIn),
                      ),
                      IconButton(
                        onPressed: () async => await launchUrl(
                          Uri.parse('https://github.com/ElanDeyan'),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.github),
                      ),
                      IconButton(
                        onPressed: () async => await launchUrl(
                          Uri.parse(
                            'https://youtube.com/@deyanwithcode?si=HB1KS0Ys3fqQBkAk',
                          ),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.youtube),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
