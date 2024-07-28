Map<String, dynamic> generateBackupFileContent({
  bool preferences = true,
  bool themeMode = true,
  bool colorPalette = true,
  bool language = true,
  dynamic tags,
  dynamic quotes,
}) {
  return {
    if (preferences)
      'preferences': {
        if (themeMode) 'themeMode': 'system',
        if (colorPalette) 'colorPalette': 'blue',
        if (language) 'language': 'en',
      },
    if (tags != null && tags != false) 'tags': tags,
    if (quotes != null && quotes != false) 'quotes': quotes,
  };
}
