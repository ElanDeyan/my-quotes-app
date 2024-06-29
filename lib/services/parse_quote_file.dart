import 'dart:convert';

import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

final _jsonExtensionRegex = RegExp(r'\.json$', caseSensitive: false);

typedef QuoteAndTags = ({Quote quote, List<String> tags});

Future<QuoteAndTags?> parseQuoteFile(
  XFile file,
) async {
  late final dynamic decodedFile;

  try {
    decodedFile = jsonDecode(await file.readAsString());
  } catch (_) {
    return null;
  }

  if (decodedFile
      case {
        "content": String _,
        "author": String _,
        "source": String? _,
        "sourceUri": String? _,
        "isFavorite": bool _,
        "tags": final List<dynamic>? tags,
      }) {
    final jsonFile = decodedFile as Map<String, dynamic>;

    jsonFile.update(
      "tags",
      (value) => null,
      ifAbsent: () => null,
    );

    final jsonFileAsQuote = Quote.fromJson(jsonFile);

    return (
      quote: jsonFileAsQuote,
      tags: tags?.cast<String>() ?? const <String>[],
    );
  }
  return null;
}

bool _isJsonFile(XFile file) =>
    _jsonExtensionRegex.hasMatch(p.extension(file.name));
