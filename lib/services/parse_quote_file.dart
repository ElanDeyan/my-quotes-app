import 'dart:convert';

import 'package:my_quotes/constants/enums/parse_quote_file_errors.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:share_plus/share_plus.dart';

typedef QuoteAndTags = ({Quote quote, List<String> tags});
typedef QuoteFileParsingResult = ({
  QuoteAndTags? data,
  ParseQuoteFileErrors? error
});

Future<QuoteFileParsingResult> parseQuoteFile(
  XFile file,
) async {
  late final Object? decodedFile;

  try {
    decodedFile = jsonDecode(utf8.decode(await file.readAsBytes()));
  } catch (_) {
    return (data: null, error: ParseQuoteFileErrors.notJsonFormat);
  }

  if (decodedFile is! Map<String, Object?>) {
    return (data: null, error: ParseQuoteFileErrors.notJsonMap);
  }

  if (decodedFile
      case {
        "content": String _,
        "author": String _,
        "source": String? _,
        "sourceUri": String? _,
        "isFavorite": bool _,
        "tags": final List<Object?>? tags,
      } when tags?.every((item) => item is String) ?? true) {
    final jsonFile = decodedFile;

    jsonFile.update(
      "tags",
      (value) => null,
      ifAbsent: () => null,
    );

    final jsonFileAsQuote = Quote.fromJson(jsonFile);

    return (
      data: (
        quote: jsonFileAsQuote,
        tags: tags?.map((item) => item.toString()).toList() ?? const <String>[],
      ),
      error: null
    );
  }
  return (data: null, error: ParseQuoteFileErrors.notCaseFieldsAndTypes);
}
