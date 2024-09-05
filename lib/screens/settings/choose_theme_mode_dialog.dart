import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/repository/interfaces/theme_mode_repository.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';

class ChooseThemeModeDialog extends StatelessWidget {
  const ChooseThemeModeDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appPreferences = Provider.of<AppPreferences>(context, listen: false);

    return SimpleDialog(
      clipBehavior: Clip.none,
      title: Text(context.appLocalizations.chooseThemeModeMessage),
      children: List.generate(
        ThemeModeRepository.values.length,
        (index) {
          final themeMode = ThemeModeRepository.values[index];
          return SimpleDialogOption(
            onPressed: () => appPreferences.themeMode = themeMode,
            child: Text(
              context.appLocalizations.themeModeName(
                themeMode.name,
              ),
            ),
          );
        },
        growable: false,
      ),
    );
  }
}
