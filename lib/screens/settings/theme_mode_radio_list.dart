import 'package:flutter/material.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';

final class ThemeModeRadioList extends StatefulWidget {
  const ThemeModeRadioList({super.key});

  @override
  State<ThemeModeRadioList> createState() => _ThemeModeRadioListState();
}

final class _ThemeModeRadioListState extends State<ThemeModeRadioList> {
  late ThemeMode _themeModeGroupValue;
  @override
  Widget build(BuildContext context) {
    final preferences = Provider.of<AppPreferences>(context);
    _themeModeGroupValue = preferences.themeMode;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Choose a theme mode:'),
        for (final themeMode in ThemeMode.values)
          RadioListTile(
            value: themeMode,
            groupValue: _themeModeGroupValue,
            onChanged: (value) => setState(() {
              _themeModeGroupValue = value!;
              preferences.themeMode = value;
            }),
            selected: _themeModeGroupValue == themeMode,
            title: Text(themeMode.name),
          ),
      ],
    );
  }
}
