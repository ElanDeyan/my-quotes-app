import 'package:flutter/material.dart';

enum ColorSchemePalette {
  coolBlush(uiName: 'Cool blush', storageName: 'cool_blush'),
  fireEngineRed(uiName: 'Fire engine red', storageName: 'fire_engine_red'),
  icyLilac(uiName: 'Icy lilac', storageName: 'icy_lilac'),
  mistyMint(uiName: 'Misty mint', storageName: 'misty_mint'),
  oxfordBlue(uiName: 'Oxford blue', storageName: 'oxford_blue'),
  powderBlue(uiName: 'Powder blue', storageName: 'powder_blue'),
  softApricot(uiName: 'Soft apricot', storageName: 'soft_apricot'),
  vanilla(uiName: 'Vanilla', storageName: 'vanilla');

  const ColorSchemePalette({
    required this.uiName,
    required this.storageName,
  });

  final String uiName;
  final String storageName;

  static ColorScheme lightColorScheme(ColorSchemePalette colorScheme) =>
      switch (colorScheme) {
        ColorSchemePalette.oxfordBlue =>
          ColorScheme.fromSeed(seedColor: const Color(0xff061A40)),
        ColorSchemePalette.fireEngineRed =>
          ColorScheme.fromSeed(seedColor: const Color(0xffc42021)),
        ColorSchemePalette.vanilla =>
          ColorScheme.fromSeed(seedColor: const Color(0xfff1e8b8)),
        ColorSchemePalette.mistyMint =>
          ColorScheme.fromSeed(seedColor: const Color(0xffC5E3D5)),
        ColorSchemePalette.softApricot =>
          ColorScheme.fromSeed(seedColor: const Color(0xffF9C6A4)),
        ColorSchemePalette.coolBlush =>
          ColorScheme.fromSeed(seedColor: const Color(0xffEAC2C3)),
        ColorSchemePalette.powderBlue =>
          ColorScheme.fromSeed(seedColor: const Color(0xffA3C4E5)),
        ColorSchemePalette.icyLilac =>
          ColorScheme.fromSeed(seedColor: const Color(0xffD1C5E0)),
      };

  static ColorScheme darkColorScheme(ColorSchemePalette colorScheme) =>
      switch (colorScheme) {
        ColorSchemePalette.oxfordBlue => ColorScheme.fromSeed(
            seedColor: const Color(0xff061A40),
            brightness: Brightness.dark,
          ),
        ColorSchemePalette.fireEngineRed => ColorScheme.fromSeed(
            seedColor: const Color(0xffc42021),
            brightness: Brightness.dark,
          ),
        ColorSchemePalette.vanilla => ColorScheme.fromSeed(
            seedColor: const Color(0xfff1e8b8),
            brightness: Brightness.dark,
          ),
        ColorSchemePalette.mistyMint => ColorScheme.fromSeed(
            seedColor: const Color(0xffC5E3D5),
            brightness: Brightness.dark,
          ),
        ColorSchemePalette.softApricot => ColorScheme.fromSeed(
            seedColor: const Color(0xffF9C6A4),
            brightness: Brightness.dark,
          ),
        ColorSchemePalette.coolBlush => ColorScheme.fromSeed(
            seedColor: const Color(0xffEAC2C3),
            brightness: Brightness.dark,
          ),
        ColorSchemePalette.powderBlue => ColorScheme.fromSeed(
            seedColor: const Color(0xffA3C4E5),
            brightness: Brightness.dark,
          ),
        ColorSchemePalette.icyLilac => ColorScheme.fromSeed(
            seedColor: const Color(0xffD1C5E0),
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
