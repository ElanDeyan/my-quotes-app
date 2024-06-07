import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/color_pallete.dart';
import 'package:my_quotes/helpers/string_extension.dart';
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

  static const screenName = 'Settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.canPop() ? context.pop(context) : context.pushNamed('mainScreen'),
        ),
        title: const Text(screenName),
      ),
      body: Consumer<AppPreferences>(
        builder: (context, value, child) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.brightness_medium),
              title: const Text('Theme mode'),
              subtitle: Text(
                value.themeMode.name.toTitleCase(),
              ),
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => const Dialog(
                  child: ThemeModeRadioList(),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Color pallete'),
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
                  Text(value.colorSchemePalette.uiName),
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
              leading: const Icon(Icons.translate),
              title: const Text('App language'),
              subtitle: Text(value.language),
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => const Dialog(
                  child: LanguageRadioList(),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('App info'),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'My Quotes',
                applicationVersion: '0.1.0',
                applicationIcon: const Icon(Icons.format_quote),
                children: [
                  const Text('Thanks for using this app!'),
                  const Text("I hope you're enjoying!"),
                  const Text(
                    'To support my work, share with your friends and follow me in my medias:',
                  ),
                  Wrap(
                    spacing: 5.0,
                    children: <IconButton>[
                      IconButton(
                        onPressed: () async => await launchUrl(
                          Uri.parse(
                            'https://www.linkedin.com/in/elan-almeida-a3391225b/',
                          ),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.linkedin),
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
