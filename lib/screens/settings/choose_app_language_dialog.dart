import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/repository/interfaces/language_repository.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';

class ChooseAppLanguageDialog extends StatelessWidget {
  const ChooseAppLanguageDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appPreferences = Provider.of<AppPreferences>(context, listen: false);

    return SimpleDialog(
      clipBehavior: Clip.none,
      title: Text(context.appLocalizations.chooseAppLanguage),
      children: List.generate(
        LanguageRepository.values.length,
        (index) {
          final language = LanguageRepository.values[index];

          return SimpleDialogOption(
            onPressed: () => appPreferences.language = language,
            child: Text(
              context.appLocalizations.languageName(language),
              softWrap: true,
            ),
          );
        },
        growable: false,
      ),
    );
  }
}
