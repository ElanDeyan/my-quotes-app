import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract interface class LanguageRepository {
  static const languageKey = 'language';

  static final defaultLanguage = AppLocalizations.supportedLocales
      .where((element) => element == const Locale('en'))
      .single;

  static final values = AppLocalizations.supportedLocales
      .map((locale) => locale.languageCode)
      .toList();

  Future<String> get language;

  Future<void> setLanguage(String language);
}
