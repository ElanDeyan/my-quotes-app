import 'package:flutter/material.dart';
import 'package:my_quotes/constants/color_pallete.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';

final class ColorPalleteRadioList extends StatefulWidget {
  const ColorPalleteRadioList({super.key});

  @override
  State<ColorPalleteRadioList> createState() => _ColorPalleteRadioListState();
}

final class _ColorPalleteRadioListState extends State<ColorPalleteRadioList> {
  late ColorPallete _colorPalleteGroupValue;
  @override
  Widget build(BuildContext context) {
    final preferences = Provider.of<AppPreferences>(context);
    _colorPalleteGroupValue = preferences.colorPallete;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Choose a color pallete:'),
        for (final colorPallete in ColorPallete.values)
          RadioListTile(
            value: colorPallete,
            groupValue: _colorPalleteGroupValue,
            onChanged: (value) => setState(() {
              _colorPalleteGroupValue = value!;
              preferences.colorPallete = value;
            }),
            selected: _colorPalleteGroupValue == colorPallete,
            title: Text(colorPallete.name),
          ),
      ],
    );
  }
}
