Map<String, Object?> generateBackupFileContent({
  bool preferences = true,
  dynamic themeMode = 'system',
  dynamic colorPalette = 'blue',
  dynamic language = 'en',
  dynamic tags,
  dynamic quotes,
}) {
  return {
    if (preferences)
      'preferences': {
        if (themeMode != null && themeMode != false) 'themeMode': themeMode,
        if (colorPalette != null && colorPalette != false)
          'colorPalette': colorPalette,
        if (language != null && language != false) 'language': language,
      },
    if (tags != null && tags != false) 'tags': tags,
    if (quotes != null && quotes != false) 'quotes': quotes,
  };
}
