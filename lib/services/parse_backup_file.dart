import 'dart:convert';

import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/iterable_extension.dart';
import 'package:share_plus/share_plus.dart';

typedef UserPreferencesData = ({
  String themeMode,
  String colorPalette,
  String language
});

typedef BackupData = ({
  UserPreferencesData userPreferencesData,
  List<Tag> tags,
  List<Quote> quotes
});

Future<BackupData?> parseBackupFile(XFile file) async {
  late final dynamic decodedFile;

  try {
    decodedFile = jsonDecode(utf8.decode(await file.readAsBytes()));
  } catch (_) {
    return null;
  }

  if (decodedFile
      case {
        "preferences": final Map<String, dynamic> preferencesMap,
        "tags": final List<dynamic> tags,
        "quotes": final List<dynamic> quotes,
      }) {
    late final UserPreferencesData userPreferences;
    late final List<Tag> tagsList;
    late final List<Quote> quotesList;

    if (preferencesMap
        case {
          "themeMode": final String themeMode,
          "colorPalette": final String colorPalette,
          "language": final String language,
        }) {
      userPreferences = (
        themeMode: themeMode,
        colorPalette: colorPalette,
        language: language
      );
    } else {
      return null;
    }

    if (_validateTagsData(tags)) {
      tagsList = tags
          .map(
            (item) => Tag(
              id: int.parse((item as Map<String, dynamic>).keys.single),
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
        item is Map<String, dynamic> &&
        item.values.every((value) => value is String) &&
        item.keys.length == 1 &&
        int.tryParse(item.keys.single) != null &&
        item.keys.map(int.parse).isMadeOfUniques,
  );
}

bool _validateQuotesData(List<dynamic> data) {
  if (!data.every((item) => item is Map<String, dynamic>)) {
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
      .map((item) => Quote.fromJson(item as Map<String, dynamic>))
      .toList();
}
