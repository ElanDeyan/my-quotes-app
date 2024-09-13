import 'package:my_quotes/repository/color_scheme_palette_repository.dart';
import 'package:my_quotes/repository/language_repository.dart';
import 'package:my_quotes/repository/theme_mode_repository.dart';
import 'package:my_quotes/repository/user_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class UserPreferencesWithSharedPreferencesAsync
    implements UserPreferencesRepository {
  const UserPreferencesWithSharedPreferencesAsync(this.sharedPreferencesAsync);

  final SharedPreferencesAsync sharedPreferencesAsync;

  String get _defaultColorPallete =>
      ColorSchemePaletteRepository.defaultColorSchemePalette.uiName;
  String get _defaultThemeMode => ThemeModeRepository.defaultThemeMode.name;
  String get _defaultLanguage => LanguageRepository.defaultLanguage.toString();

  @override
  Future<String> get colorSchemePalette => _getStringPreference(
        ColorSchemePaletteRepository.colorSchemePaletteKey,
        orElse: _defaultColorPallete,
      );

  @override
  Future<void> setColorSchemePalette(String colorPallete) =>
      _setStringPreference(
        ColorSchemePaletteRepository.colorSchemePaletteKey,
        colorPallete,
      );

  @override
  Future<String> get language => _getStringPreference(
        LanguageRepository.languageKey,
        orElse: _defaultLanguage,
      );

  @override
  Future<void> setLanguage(String language) =>
      _setStringPreference(LanguageRepository.languageKey, language);

  @override
  Future<String> get themeMode => _getStringPreference(
        ThemeModeRepository.themeModeKey,
        orElse: _defaultThemeMode,
      );

  @override
  Future<void> setThemeMode(String themeMode) => _setStringPreference(
        ThemeModeRepository.themeModeKey,
        themeMode,
      );

  Future<String> _getStringPreference(
    String key, {
    required String orElse,
  }) async =>
      await sharedPreferencesAsync.getString(key) ?? orElse;

  Future<void> _setStringPreference(String key, String value) =>
      sharedPreferencesAsync.setString(key, value);
}
