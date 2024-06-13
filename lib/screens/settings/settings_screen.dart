import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/color_pallete.dart';
import 'package:my_quotes/helpers/string_extension.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/settings/color_pallete_radio_list.dart';
import 'package:my_quotes/screens/settings/language_radio_list.dart';
import 'package:my_quotes/screens/settings/theme_mode_radio_list.dart';
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
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Consumer<AppPreferences>(
        builder: (context, value, child) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.brightness_medium_outlined),
              title: Text(AppLocalizations.of(context)!.themeMode),
              subtitle: Text(
                AppLocalizations.of(context)!
                    .themeModeName(value.themeMode.name)
                    .toTitleCase(),
              ),
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => const Dialog(
                  child: ThemeModeRadioList(),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: Text(AppLocalizations.of(context)!.colorPallete),
              subtitle: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: ColorSchemePalette.primaryColor(
                      context,
                      value.colorSchemePalette,
                      MediaQuery.platformBrightnessOf(context),
                    ),
                    minRadius: 5.0,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .colorPaletteName(value.colorSchemePalette.storageName),
                  ),
                ],
              ),
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => const Dialog(
                  child: ColorSchemePaletteRadioList(),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.translate_outlined),
              title: Text(AppLocalizations.of(context)!.language),
              subtitle: Text(
                AppLocalizations.of(context)!.languageName(value.language),
              ),
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => const Dialog(
                  child: LanguageRadioList(),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(AppLocalizations.of(context)!.info),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'My Quotes',
                applicationVersion: '0.1.0',
                applicationIcon: const Icon(Icons.format_quote),
                children: [
                  Text(AppLocalizations.of(context)!.infoDescription),
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
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.instagram),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.medium),
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
