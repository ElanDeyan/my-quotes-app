import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';

final class LanguageRadioList extends StatefulWidget {
  const LanguageRadioList({super.key});

  @override
  State<LanguageRadioList> createState() => _LanguageRadioListState();
}

final class _LanguageRadioListState extends State<LanguageRadioList> {
  late String _languageGroupValue;
  @override
  Widget build(BuildContext context) {
    final preferences = Provider.of<AppPreferences>(context);
    _languageGroupValue = preferences.language;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.appLocalizations.chooseAppLanguage,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              ),
            ),
            for (final language
                in AppLocalizations.supportedLocales.map((e) => e.toString()))
              RadioListTile(
                value: language,
                groupValue: _languageGroupValue,
                onChanged: (value) => setState(() {
                  _languageGroupValue = value!;
                  preferences.language = value;
                }),
                selected: _languageGroupValue == language,
                title: Text(context.appLocalizations.languageName(language)),
              ),
          ],
        ),
      ),
    );
  }
}
