import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_quotes/constants/color_pallete.dart';
import 'package:my_quotes/repository/user_preferences.dart';
import 'package:my_quotes/repository/user_preferences_interfaces.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

final mockPreferences = <String, String>{
  ColorPalleteRepository.colorPalleteKey: ColorPallete.amber.name,
  ThemeModeRepository.themeModeKey: ThemeMode.light.name,
  LanguageRepository.languageKey: 'pt-BR',
};

void main() async {
  SharedPreferences.setMockInitialValues(mockPreferences);
  const userPreferencesHandler = UserPreferences();
  final appPreferences =
      AppPreferences(userPreferencesRepository: userPreferencesHandler);

  group('Getters', () {
    test('Theme mode', () {
      expect(
        appPreferences.themeMode.name,
        equals(mockPreferences[ThemeModeRepository.themeModeKey]),
      );
    });
    test('Color pallete', () {
      expect(
        appPreferences.colorPallete.name,
        equals(mockPreferences[ColorPalleteRepository.colorPalleteKey]),
      );
    });
    test('Language', () {
      expect(
        appPreferences.language,
        equals(mockPreferences[LanguageRepository.languageKey]),
      );
    });
  });

  group('Setters', () {
    group('Theme mode', () {
      for (final themeMode in ThemeMode.values) {
        test('Setting $themeMode', () {
          appPreferences.themeMode = themeMode;
          expect(appPreferences.themeMode, themeMode);
        });
      }
    });
    group('Color pallete', () {
      for (final colorPallete in ColorPallete.values) {
        test('Setting $colorPallete', () {
          appPreferences.colorPallete = colorPallete;
          expect(appPreferences.colorPallete, colorPallete);
        });
      }
    });
    group('Language', () {
      for (final language in const <String>['en', 'pt-BR']) {
        test('Setting $language', () {
          appPreferences.language = language;
          expect(appPreferences.language, language);
        });
      }
    });
  });

  group('Are changes saved locally?', () {
    test('Theme mode', () async {
      var localThemeMode = await userPreferencesHandler.themeMode;
      final themeModeValuesExceptLocal =
          ThemeMode.values.where((element) => element.name != localThemeMode);
      expect(
        themeModeValuesExceptLocal,
        hasLength(ThemeMode.values.length - 1),
      );

      for (final themeModeToAssign in themeModeValuesExceptLocal) {
        localThemeMode = await userPreferencesHandler
            .themeMode; // updates for next iteration

        final oldLocalThemeMode = localThemeMode;

        expect(appPreferences.themeMode.name, equals(oldLocalThemeMode));

        appPreferences.themeMode = themeModeToAssign;

        await Future<void>.delayed(Duration.zero); // delay to simulate writing

        expect(appPreferences.themeMode.name, equals(themeModeToAssign.name));

        final newLocalThemeMode = await userPreferencesHandler.themeMode;

        expect(oldLocalThemeMode, isNot(newLocalThemeMode));
      }
    });
    test('Color pallete', () async {
      var localColorPallete = await userPreferencesHandler.colorPallete;
      final colorPalleteValuesExceptLocal = ColorPallete.values
          .where((element) => element.name != localColorPallete);
      expect(
        colorPalleteValuesExceptLocal,
        hasLength(ColorPallete.values.length - 1),
      );

      for (final colorPalleteToAssign in colorPalleteValuesExceptLocal) {
        localColorPallete = await userPreferencesHandler
            .colorPallete; // updates for next iteration

        final oldLocalColorPallete = localColorPallete;

        expect(appPreferences.colorPallete.name, equals(oldLocalColorPallete));

        appPreferences.colorPallete = colorPalleteToAssign;

        await Future<void>.delayed(Duration.zero); // delay to simulate writing

        expect(
          appPreferences.colorPallete.name,
          equals(colorPalleteToAssign.name),
        );

        final newLocalThemeMode = await userPreferencesHandler.colorPallete;

        expect(oldLocalColorPallete, isNot(newLocalThemeMode));
      }
    });
    test('Language', () async {
      const languagesSample = <String>[
        'en',
        'pt-BR',
        'es',
        'fr',
      ];
      var localLanguage = await userPreferencesHandler.language;
      final languagesValuesExceptLocal =
          languagesSample.where((element) => element != localLanguage);

      expect(
        languagesValuesExceptLocal,
        hasLength(languagesSample.length - 1),
      );

      for (final languageToAssign in languagesValuesExceptLocal) {
        localLanguage =
            await userPreferencesHandler.language; // updates for next iteration

        final oldLocalLanguage = localLanguage;

        expect(appPreferences.language, equals(oldLocalLanguage));

        appPreferences.language = languageToAssign;

        await Future<void>.delayed(Duration.zero); // delay to simulate writing

        expect(appPreferences.language, equals(languageToAssign));

        final newLocalLanguage = await userPreferencesHandler.language;

        expect(oldLocalLanguage, isNot(newLocalLanguage));
      }
    });
  });
}
