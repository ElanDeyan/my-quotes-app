import 'package:flutter/material.dart';
import 'package:my_quotes/constants/enums/color_scheme_palette.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';

final class ColorSchemePaletteRadioList extends StatefulWidget {
  const ColorSchemePaletteRadioList({super.key});

  @override
  State<ColorSchemePaletteRadioList> createState() =>
      _ColorSchemePaletteRadioListState();
}

final class _ColorSchemePaletteRadioListState
    extends State<ColorSchemePaletteRadioList> {
  late ColorSchemePalette _colorSchemePaletteGroupValue;
  @override
  Widget build(BuildContext context) {
    final preferences = Provider.of<AppPreferences>(context);
    _colorSchemePaletteGroupValue = preferences.colorSchemePalette;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.appLocalizations.chooseColorPaletteMessage,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              ),
            ),
            for (final colorSchemePalette in ColorSchemePalette.values)
              RadioListTile(
                value: colorSchemePalette,
                groupValue: _colorSchemePaletteGroupValue,
                onChanged: (value) => setState(() {
                  _colorSchemePaletteGroupValue = value!;
                  preferences.colorSchemePalette = value;
                }),
                selected: _colorSchemePaletteGroupValue == colorSchemePalette,
                title: Text(
                  context.appLocalizations
                      .colorPaletteName(colorSchemePalette.storageName),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
