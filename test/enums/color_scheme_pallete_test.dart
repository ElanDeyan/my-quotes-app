import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_quotes/constants/enums/color_scheme_palette.dart';

void main() {
  test('Is light color scheme?', () {
    final randomColorSchemes = List.of(ColorSchemePalette.values)..shuffle();

    for (final colorSchemePalette in randomColorSchemes) {
      expect(
        ColorSchemePalette.lightColorScheme(colorSchemePalette).brightness ==
            Brightness.light,
        isTrue,
      );
    }
  });

  test('Is dark color scheme?', () {
    final randomColorSchemes = List.of(ColorSchemePalette.values)..shuffle();

    for (final colorSchemePalette in randomColorSchemes) {
      expect(
        ColorSchemePalette.darkColorScheme(colorSchemePalette).brightness ==
            Brightness.dark,
        isTrue,
      );
    }
  });
}
