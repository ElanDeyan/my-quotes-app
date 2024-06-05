import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

enum ColorSchemePalette {
  deepBlue(uiName: 'Deep Blue', storageName: 'deep_blue'),
  indigo(uiName: 'Indigo', storageName: 'indigo'),
  mandyRed(uiName: 'Mandy red', storageName: 'mandy_red'),
  green(uiName: 'Green Forest', storageName: 'green'),
  gold(uiName: 'Gold', storageName: 'gold'),
  bigStone(uiName: 'Big Stone Tulip', storageName: 'big_stone_tulip'),
  espresso(uiName: 'Espresso and Crema', storageName: 'espresso_and_crema'),
  outerSpace(uiName: 'Outer Space Stage', storageName: 'outer_space_stage'),
  rosewood(uiName: 'Rosewood', storageName: 'rosewood'),
  flutterDash(uiName: 'Flutter Dash', storageName: 'flutter_dash'),
  orange(uiName: 'Orange', storageName: 'orange');

  const ColorSchemePalette({
    required this.uiName,
    required this.storageName,
  });

  final String uiName;
  final String storageName;

  static ThemeData lightColorScheme(ColorSchemePalette colorScheme) => switch(colorScheme) {
    ColorSchemePalette.deepBlue => FlexThemeData.light(scheme: FlexScheme.deepBlue),
    ColorSchemePalette.indigo => FlexThemeData.light(scheme: FlexScheme.indigoM3),
    ColorSchemePalette.mandyRed => FlexThemeData.light(scheme: FlexScheme.mandyRed),
    ColorSchemePalette.green => FlexThemeData.light(scheme: FlexScheme.greenM3),
    ColorSchemePalette.gold => FlexThemeData.light(scheme: FlexScheme.gold),
    ColorSchemePalette.bigStone => FlexThemeData.light(scheme: FlexScheme.bigStone),
    ColorSchemePalette.espresso => FlexThemeData.light(scheme: FlexScheme.espresso),
    ColorSchemePalette.outerSpace => FlexThemeData.light(scheme: FlexScheme.outerSpace),
    ColorSchemePalette.rosewood => FlexThemeData.light(scheme: FlexScheme.rosewood),
    ColorSchemePalette.flutterDash => FlexThemeData.light(scheme: FlexScheme.flutterDash),
    ColorSchemePalette.orange => FlexThemeData.light(scheme: FlexScheme.orangeM3),
  };

  static ThemeData darkColorScheme(ColorSchemePalette colorScheme) => switch(colorScheme) {
    ColorSchemePalette.deepBlue => FlexThemeData.dark(scheme: FlexScheme.deepBlue),
    ColorSchemePalette.indigo => FlexThemeData.dark(scheme: FlexScheme.indigoM3),
    ColorSchemePalette.mandyRed => FlexThemeData.dark(scheme: FlexScheme.mandyRed),
    ColorSchemePalette.green => FlexThemeData.dark(scheme: FlexScheme.greenM3),
    ColorSchemePalette.gold => FlexThemeData.dark(scheme: FlexScheme.gold),
    ColorSchemePalette.bigStone => FlexThemeData.dark(scheme: FlexScheme.bigStone),
    ColorSchemePalette.espresso => FlexThemeData.dark(scheme: FlexScheme.espresso),
    ColorSchemePalette.outerSpace => FlexThemeData.dark(scheme: FlexScheme.outerSpace),
    ColorSchemePalette.rosewood => FlexThemeData.dark(scheme: FlexScheme.rosewood),
    ColorSchemePalette.flutterDash => FlexThemeData.dark(scheme: FlexScheme.flutterDash),
    ColorSchemePalette.orange => FlexThemeData.dark(scheme: FlexScheme.orangeM3),
  };

  static Color primaryColor(BuildContext context, ColorSchemePalette colorScheme, Brightness localBrightness) => switch ((colorScheme, localBrightness)) {
    (ColorSchemePalette.deepBlue, Brightness.light) => FlexColor.deepBlueLightPrimary,
    (ColorSchemePalette.deepBlue, Brightness.dark) => FlexColor.deepBlueDarkPrimary,
    (ColorSchemePalette.indigo, Brightness.light) => FlexColor.indigoM3LightPrimary,
    (ColorSchemePalette.indigo, Brightness.dark) => FlexColor.indigoM3DarkPrimary,
    (ColorSchemePalette.mandyRed, Brightness.light) => FlexColor.mandyRedLightPrimary,
    (ColorSchemePalette.mandyRed, Brightness.dark) => FlexColor.mandyRedDarkPrimary,
    (ColorSchemePalette.green, Brightness.light) => FlexColor.greenM3LightPrimary,
    (ColorSchemePalette.green, Brightness.dark) => FlexColor.greenM3DarkPrimary,
    (ColorSchemePalette.gold, Brightness.light) => FlexColor.goldLightPrimary,
    (ColorSchemePalette.gold, Brightness.dark) => FlexColor.goldDarkPrimary,
    (ColorSchemePalette.bigStone, Brightness.light) => FlexColor.bigStoneLightPrimary,
    (ColorSchemePalette.bigStone, Brightness.dark) => FlexColor.bigStoneDarkPrimary,
    (ColorSchemePalette.espresso, Brightness.light) => FlexColor.espressoLightPrimary,
    (ColorSchemePalette.espresso, Brightness.dark) => FlexColor.espressoDarkPrimary,
    (ColorSchemePalette.outerSpace, Brightness.light) => FlexColor.outerSpaceLightPrimary,
    (ColorSchemePalette.outerSpace, Brightness.dark) => FlexColor.outerSpaceDarkPrimary,
    (ColorSchemePalette.rosewood, Brightness.light) => FlexColor.rosewoodLightPrimary,
    (ColorSchemePalette.rosewood, Brightness.dark) => FlexColor.rosewoodDarkPrimary,
    (ColorSchemePalette.flutterDash, Brightness.light) => FlexColor.flutterDash.light.primary,
    (ColorSchemePalette.flutterDash, Brightness.dark) => FlexColor.flutterDash.dark.primary,
    (ColorSchemePalette.orange, Brightness.light) => FlexColor.orangeM3LightPrimary,
    (ColorSchemePalette.orange, Brightness.dark) => FlexColor.orangeM3DarkPrimary,
  };
}
