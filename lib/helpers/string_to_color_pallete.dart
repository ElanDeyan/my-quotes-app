import 'package:my_quotes/constants/color_pallete.dart';

extension ColorPalleteExtension on ColorPallete {
  static ColorPallete colorPalleteFromString(String string) {
    const colorPalleteValues = ColorPallete.values;

    for (final colorPallete in colorPalleteValues) {
      if (string.toLowerCase().compareTo(colorPallete.name.toLowerCase()) ==
          0) {
        return colorPallete;
      }
    }

    throw ArgumentError.value(string, null, 'Invalid color pallete value');
  }
}
