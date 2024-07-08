import 'package:my_quotes/constants/enums/color_scheme_pallete.dart';

extension ColorSchemePaletteExtension on ColorSchemePalette {
  static ColorSchemePalette? colorSchemePaletteFromString(String string) {
    const colorSchemePaletteValues = ColorSchemePalette.values;

    for (final colorSchemePalette in colorSchemePaletteValues) {
      if (string
              .toLowerCase()
              .compareTo(colorSchemePalette.storageName.toLowerCase()) ==
          0) {
        return colorSchemePalette;
      }
    }

    return null;
  }
}
