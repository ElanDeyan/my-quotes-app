import 'package:my_quotes/constants/enums/color_scheme_pallete.dart';

extension ColorSchemePaletteExtension on ColorSchemePalette {
  static ColorSchemePalette? colorSchemePaletteFromString(String string) {
    const colorSchemePaletteValues = ColorSchemePalette.values;

    for (final colorSchemePalette in colorSchemePaletteValues) {
      final storageNameRegExp = RegExp(colorSchemePalette.storageName);
      final uiNameRegExp = RegExp(colorSchemePalette.uiName);

      if (storageNameRegExp.hasMatch(string) || uiNameRegExp.hasMatch(string)) {
        return colorSchemePalette;
      }
    }

    return null;
  }
}
