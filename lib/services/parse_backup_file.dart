import 'dart:convert';

import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/iterable_extension.dart';
import 'package:my_quotes/repository/color_scheme_palette_repository.dart';
import 'package:my_quotes/repository/language_repository.dart';
import 'package:my_quotes/repository/secure_repository.dart';
import 'package:my_quotes/repository/theme_mode_repository.dart';
import 'package:my_quotes/services/decrypt_backup_data.dart';
import 'package:share_plus/share_plus.dart';

typedef UserPreferencesData = ({
  String themeMode,
  String colorPalette,
  String language,
  String allowErrorReporting,
});

typedef BackupData = ({
  UserPreferencesData userPreferencesData,
  List<Tag> tags,
  List<Quote> quotes
});

final _themeModeValues =
    ThemeModeRepository.values.map((themeMode) => themeMode.name);
final _colorSchemePaletteValues = ColorSchemePaletteRepository.values
    .map((colorSchemePalette) => colorSchemePalette.storageName);
final _languageValues = LanguageRepository.values;

Future<BackupData?> parseBackupFile(
  ({XFile file, String password}) data,
) async {
  late final String decryptedData;

  try {
    decryptedData =
        decryptBackupData(data.password, await data.file.readAsBytes());
  } catch (_) {
    return null;
  }

  late final dynamic decodedFile;

  try {
    decodedFile = jsonDecode(decryptedData);
  } catch (_) {
    return null;
  }

  if (decodedFile
      case {
        "preferences": final Map<String, Object?> preferencesMap,
        "tags": final List<dynamic> tags,
        "quotes": final List<dynamic> quotes,
      }) {
    late final UserPreferencesData userPreferences;
    late final List<Tag> tagsList;
    late final List<Quote> quotesList;

    if (preferencesMap
        case {
          ThemeModeRepository.themeModeKey: final String themeMode,
          ColorSchemePaletteRepository.colorSchemePaletteKey: final String
              colorPalette,
          LanguageRepository.languageKey: final String language,
          SecureRepository.allowErrorReportingKey: final String
              allowErrorReporting,
        }
        when _themeModeValues.contains(themeMode) &&
            _colorSchemePaletteValues.contains(colorPalette) &&
            _languageValues.contains(language) &&
            bool.tryParse(allowErrorReporting) != null) {
      userPreferences = (
        themeMode: themeMode,
        colorPalette: colorPalette,
        language: language,
        allowErrorReporting: allowErrorReporting,
      );
    } else {
      return null;
    }

    if (_validateTagsData(tags)) {
      tagsList = tags
          .map(
            (item) => Tag(
              id: int.parse((item as Map<String, Object?>).keys.single),
              name: item.values.single.toString(),
            ),
          )
          .toList();
    } else {
      return null;
    }

    if (_validateQuotesData(quotes)) {
      quotesList = _createQuotesFromJson(quotes);
    } else {
      return null;
    }

    return (
      userPreferencesData: userPreferences,
      tags: tagsList,
      quotes: quotesList
    );
  }

  return null;
}

bool _validateTagsData(List<dynamic> data) {
  return data.every(
        (item) =>
            item is Map<String, Object?> &&
            item.keys.length == 1 &&
            int.tryParse(item.keys.single) != null &&
            item.values.every((value) => value is String),
      ) &&
      data
          .map((item) => int.parse((item as Map<String, Object?>).keys.single))
          .isMadeOfUniques;
}

bool _validateQuotesData(List<dynamic> data) {
  if (!data.every((item) => item is Map<String, Object?>)) {
    return false;
  }

  if (!data
      .map((element) => (element as Map<String, Object?>)['id'])
      .isMadeOfUniques) {
    return false;
  }

  for (final item in data) {
    if (item
        case {
          "id": int _,
          "content": String _,
          "author": String _,
          "source": String? _,
          "sourceUri": String? _,
          "isFavorite": bool _,
          "createdAt": int _,
          "tags": String? _,
        }) {
      return true;
    }
  }

  return true;
}

List<Quote> _createQuotesFromJson(List<dynamic> data) {
  return data
      .map((item) => Quote.fromJson(item as Map<String, Object?>))
      .toList();
}
