import 'dart:convert';

import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:share_plus/share_plus.dart';

typedef QuoteAndTags = ({Quote quote, List<String> tags});

Future<QuoteAndTags?> parseQuoteFile(
  XFile file,
) async {
  late final Object? decodedFile;

  try {
    decodedFile = jsonDecode(utf8.decode(await file.readAsBytes()));
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
        "tags": final List<Object?>? tags,
      }) {
    final jsonFile = decodedFile as Map<String, Object?>;

    jsonFile.update(
      "tags",
      (value) => null,
      ifAbsent: () => null,
    );

    final jsonFileAsQuote = Quote.fromJson(jsonFile);

    // TODO: adds more validation for tag name creation (like remove special chars, disallow spaces)
    return (
      quote: jsonFileAsQuote,
      tags: tags?.map((item) => '$item').toList() ?? const <String>[],
    );
  }
  return null;
}
