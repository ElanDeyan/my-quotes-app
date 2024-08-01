import 'package:english_words/english_words.dart' as englishWords;
import 'package:flutter_test/flutter_test.dart';
import 'package:my_quotes/constants/enums/color_scheme_palette.dart';
import 'package:my_quotes/helpers/string_to_color_pallete.dart';

void main() {
  test('Using storage name', () {
    for (final colorSchemePalette in ColorSchemePalette.values) {
      expect(
        ColorSchemePaletteExtension.colorSchemePaletteFromString(
          colorSchemePalette.storageName,
        ),
        isA<ColorSchemePalette>(),
      );
    }
  });

  test('Using ui name', () {
    for (final colorSchemePalette in ColorSchemePalette.values) {
      expect(
        ColorSchemePaletteExtension.colorSchemePaletteFromString(
          colorSchemePalette.uiName,
        ),
        isA<ColorSchemePalette>(),
      );
    }
  });

  test('Using random strings should be null', () {
    final words = englishWords.all.take(10).where(
      (word) {
        final colorSchemePaletteNames = ColorSchemePalette.values.map(
          (colorSchemePalette) =>
              (colorSchemePalette.uiName, colorSchemePalette.storageName),
        );

        return colorSchemePaletteNames
            .every((pair) => pair.$1 != word && pair.$2 != word);
      },
    );

    for (final word in words) {
      expect(
        ColorSchemePaletteExtension.colorSchemePaletteFromString(word),
        isNull,
      );
    }
  });
}
