import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

enum ColorSchemePalette {
  blue(uiName: 'Blue', storageName: 'blue'),
  caramel(uiName: 'Caramel', storageName: 'caramel'),
  espresso(uiName: 'Espresso and Crema', storageName: 'espresso_and_crema'),
  flutterDash(uiName: 'Flutter Dash', storageName: 'flutter_dash'),
  green(uiName: 'Green', storageName: 'green'),
  indigo(uiName: 'Indigo', storageName: 'indigo'),
  pink(uiName: 'Pink', storageName: 'pink'),
  vanilla(uiName: 'Vanilla', storageName: 'vanilla'),
  vividSkyBlue(uiName: 'Vivid Sky Blue', storageName: 'vivid_sky_blue'),
  ultraViolet(uiName: 'Ultra violet', storageName: 'ultra_violet');

  const ColorSchemePalette({
    required this.uiName,
    required this.storageName,
  });

  final String uiName;
  final String storageName;

  static ColorScheme lightColorScheme(ColorSchemePalette colorScheme) =>
      switch (colorScheme) {
        ColorSchemePalette.blue => ColorScheme.fromSeed(seedColor: Colors.blue),
        ColorSchemePalette.caramel => ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 192, 133, 82),
          ),
        ColorSchemePalette.espresso =>
          FlexThemeData.light(scheme: FlexScheme.espresso).colorScheme,
        ColorSchemePalette.flutterDash =>
          FlexThemeData.light(scheme: FlexScheme.flutterDash).colorScheme,
        ColorSchemePalette.green =>
          ColorScheme.fromSeed(seedColor: Colors.green),
        ColorSchemePalette.indigo =>
          ColorScheme.fromSeed(seedColor: Colors.indigo),
        ColorSchemePalette.pink => ColorScheme.fromSeed(seedColor: Colors.pink),
        ColorSchemePalette.vanilla =>
          ColorScheme.fromSeed(seedColor: const Color(0xfff1e8b8)),
        ColorSchemePalette.vividSkyBlue =>
          ColorScheme.fromSeed(seedColor: const Color(0xff54defd)),
        ColorSchemePalette.ultraViolet =>
          ColorScheme.fromSeed(seedColor: const Color(0xff52489c)),
      };

  static ColorScheme darkColorScheme(ColorSchemePalette colorScheme) =>
      switch (colorScheme) {
        ColorSchemePalette.espresso =>
          FlexThemeData.dark(scheme: FlexScheme.espresso).colorScheme,
        ColorSchemePalette.flutterDash =>
          FlexThemeData.dark(scheme: FlexScheme.flutterDash).colorScheme,
        ColorSchemePalette.blue => ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ColorSchemePalette.caramel => ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 192, 133, 82),
            brightness: Brightness.dark,
          ),
        ColorSchemePalette.green => ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
          ),
        ColorSchemePalette.indigo => ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.dark,
          ),
        ColorSchemePalette.pink => ColorScheme.fromSeed(
            seedColor: Colors.pink,
            brightness: Brightness.dark,
          ),
        ColorSchemePalette.vanilla => ColorScheme.fromSeed(
            seedColor: const Color(0xfff1e8b8),
            brightness: Brightness.dark,
          ),
        ColorSchemePalette.vividSkyBlue => ColorScheme.fromSeed(
            seedColor: const Color(0xff54defd),
            brightness: Brightness.dark,
          ),
        ColorSchemePalette.ultraViolet => ColorScheme.fromSeed(
            seedColor: const Color(0xff52489c),
            brightness: Brightness.dark,
          ),
      };

  static Color primaryColor(
    ColorSchemePalette colorScheme,
    Brightness localBrightness,
  ) =>
      switch (localBrightness) {
        Brightness.light =>
          ColorSchemePalette.lightColorScheme(colorScheme).primary,
        Brightness.dark =>
          ColorSchemePalette.darkColorScheme(colorScheme).primary,
      };
}
