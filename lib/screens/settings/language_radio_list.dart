import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Choose a language:'),
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
            title: Text(language),
          ),
      ],
    );
  }
}
