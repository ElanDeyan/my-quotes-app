import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_quotes/helpers/string_to_theme_mode.dart';

void main() {
  group('ThemeMode Extension Tests', () {
    test('Should return correct ThemeMode when string matches', () {
      expect(
        ThemeModeExtension.themeModeFromString('light'),
        equals(ThemeMode.light),
      );
      expect(
        ThemeModeExtension.themeModeFromString('dark'),
        equals(ThemeMode.dark),
      );
      expect(
        ThemeModeExtension.themeModeFromString('system'),
        equals(ThemeMode.system),
      );
    });

    test('Should return null when string does not match any ThemeMode', () {
      expect(ThemeModeExtension.themeModeFromString('unknown'), isNull);
      expect(ThemeModeExtension.themeModeFromString('wrongValue'), isNull);
      expect(
        ThemeModeExtension.themeModeFromString('randomString'),
        isNull,
      );
      expect(
        ThemeModeExtension.themeModeFromString('system2'),
        isNull,
      );
    });
  });
}
