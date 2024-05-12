import 'package:shared_preferences/shared_preferences.dart';

mixin class SharedPreferencesMixin {
  Future<SharedPreferences> get localPreferences async {
    return SharedPreferences.getInstance();
  }

  Future<String> getStringPreference(
    String key, {
    required String orElse,
  }) async {
    return (await localPreferences).getString(key) ?? orElse;
  }

  Future<bool> setStringPreference(String key, String value) async {
    return (await localPreferences).setString(key, value);
  }
}
