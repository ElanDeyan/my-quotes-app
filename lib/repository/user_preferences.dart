import 'package:my_quotes/repository/user_preferences_interfaces.dart';
import 'package:my_quotes/services/shared_preferences.dart';

final class UserPreferences
    with SharedPreferencesMixin
    implements UserPreferencesRepository {
  const UserPreferences();

  String get _defaultColorPallete =>
      ColorSchemePaletteRepository.defaultColorSchemePalette.uiName;
  String get _defaultThemeMode => ThemeModeRepository.defaultThemeMode.name;
  String get _defaultLanguage => LanguageRepository.defaultLanguage.toString();

  @override
  Future<String> get colorSchemePalette async {
    return getStringPreference(
      ColorSchemePaletteRepository.colorSchemePaletteKey,
      orElse: _defaultColorPallete,
    );
  }

  @override
  Future<bool> setColorSchemePalette(String colorPallete) async {
    return setStringPreference(
      ColorSchemePaletteRepository.colorSchemePaletteKey,
      colorPallete,
    );
  }

  @override
  Future<String> get language async {
    return getStringPreference(
      LanguageRepository.languageKey,
      orElse: _defaultLanguage,
    );
  }

  @override
  Future<bool> setLanguage(String language) async {
    return setStringPreference(LanguageRepository.languageKey, language);
  }

  @override
  Future<String> get themeMode async {
    return await getStringPreference(
      ThemeModeRepository.themeModeKey,
      orElse: _defaultThemeMode,
    );
  }

  @override
  Future<bool> setThemeMode(String themeMode) async {
    return await setStringPreference(
      ThemeModeRepository.themeModeKey,
      themeMode,
    );
  }
}
