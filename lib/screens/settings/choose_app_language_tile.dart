import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/screens/settings/choose_app_language_dialog.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';

class ChooseAppLanguageTile extends StatelessWidget {
  const ChooseAppLanguageTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<AppPreferences, String>(
      selector: (_, appPreferences) => appPreferences.language,
      builder: (context, language, child) => ListTile(
        leading: child,
        title: Text(context.appLocalizations.language),
        subtitle: Text(
          context.appLocalizations.languageName(language),
        ),
        onTap: () => showDialog<void>(
          context: context,
          builder: (_) => const ChooseAppLanguageDialog(
            key: Key('choose_app_language_dialog'),
          ),
        ),
      ),
      child: const Icon(Icons.translate_outlined),
    );
  }
}
