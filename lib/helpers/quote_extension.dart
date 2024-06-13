import 'package:basics/basics.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/nullable_extension.dart';
import 'package:my_quotes/shared/quotes/quote_actions.dart';

extension QuoteExtension on Quote {
  bool get hasSourceAndUri => source.isNotNull && sourceUri.isNotNull;

  bool get hasSource => source is String && source != '';

  bool get hasSourceUri => sourceUri.isNotNull;

  Iterable<int> get tagsId =>
      tags?.split(',').map(int.tryParse).nonNulls ?? const <int>[];

  String get shareableFormat => '''
Take a look in this quote:
"$content"
- $author${source.isNotNullOrBlank ? ", $source" : ''}.${sourceUri.isNotNullOrBlank ? '\nSee more in: $sourceUri' : ''}
''';

  bool canPerform(QuoteActions action) => switch (action) {
        QuoteActions.copyLink || QuoteActions.goToLink => hasSourceUri,
        _ => true,
      };

  String get dataForQuery {
    final stringBuffer = StringBuffer();

    stringBuffer.writeAll(
      [
        content,
        author,
        if (source.isNotNullOrBlank) source else '',
        if (sourceUri.isNotNullOrBlank) sourceUri else '',
      ],
      '\n',
    );

    return stringBuffer.toString();
  }
}
