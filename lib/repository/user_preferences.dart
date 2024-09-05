import 'package:my_quotes/repository/user_preferences_interfaces.dart';
import 'package:my_quotes/services/shared_preferences.dart';

final class UserPreferences
    with SharedPreferencesAsyncMixin
    implements UserPreferencesRepository {
  const UserPreferences();

  String get _defaultColorPallete =>
      ColorSchemePaletteRepository.defaultColorSchemePalette.uiName;
  String get _defaultThemeMode => ThemeModeRepository.defaultThemeMode.name;
  String get _defaultLanguage => LanguageRepository.defaultLanguage.toString();

  @override
  Future<String> get colorSchemePalette => getStringPreference(
        ColorSchemePaletteRepository.colorSchemePaletteKey,
        orElse: _defaultColorPallete,
      );

  @override
  Future<void> setColorSchemePalette(String colorPallete) =>
      setStringPreference(
        ColorSchemePaletteRepository.colorSchemePaletteKey,
        colorPallete,
      );

  @override
  Future<String> get language => getStringPreference(
        LanguageRepository.languageKey,
        orElse: _defaultLanguage,
      );

  @override
  Future<void> setLanguage(String language) =>
      setStringPreference(LanguageRepository.languageKey, language);

  @override
  Future<String> get themeMode => getStringPreference(
        ThemeModeRepository.themeModeKey,
        orElse: _defaultThemeMode,
      );

  @override
  Future<void> setThemeMode(String themeMode) => setStringPreference(
        ThemeModeRepository.themeModeKey,
        themeMode,
      );
}
