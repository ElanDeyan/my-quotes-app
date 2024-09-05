import 'package:shared_preferences/shared_preferences.dart';

mixin class SharedPreferencesAsyncMixin {
  static final localPreferences = SharedPreferencesAsync();

  Future<String> getStringPreference(
    String key, {
    required String orElse,
  }) async =>
      await localPreferences.getString(key) ?? orElse;

  Future<void> setStringPreference(String key, String value) =>
      localPreferences.setString(key, value);
}
