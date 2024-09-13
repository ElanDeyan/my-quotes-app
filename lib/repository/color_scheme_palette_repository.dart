import 'package:my_quotes/constants/enums/color_scheme_palette.dart';

abstract interface class ColorSchemePaletteRepository {
  static const colorSchemePaletteKey = 'colorPalette';

  static const defaultColorSchemePalette = ColorSchemePalette.oxfordBlue;

  static const values = ColorSchemePalette.values;

  Future<String> get colorSchemePalette;

  Future<void> setColorSchemePalette(String colorSchemePalette);
}
