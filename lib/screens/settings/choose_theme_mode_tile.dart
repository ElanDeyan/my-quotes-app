import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/string_extension.dart';
import 'package:my_quotes/screens/settings/choose_theme_mode_dialog.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';

class ChooseThemeModeTile extends StatelessWidget {
  const ChooseThemeModeTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<AppPreferences, ThemeMode>(
      selector: (_, appPreferences) => appPreferences.themeMode,
      child: const Icon(Icons.brightness_medium_outlined),
      builder: (context, themeMode, child) => ListTile(
        leading: child,
        title: Text(context.appLocalizations.themeMode),
        subtitle: Text(
          context.appLocalizations.themeModeName(themeMode.name).toTitleCase(),
        ),
        onTap: () => showDialog<void>(
          context: context,
          builder: (_) => const ChooseThemeModeDialog(
            key: Key('choose_theme_mode_dialog'),
          ),
        ),
      ),
    );
  }
}
