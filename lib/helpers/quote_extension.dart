import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/nullable_extension.dart';
import 'package:my_quotes/shared/actions/quotes/quote_actions.dart';
import 'package:timeago/timeago.dart' as timeago;

extension QuoteExtension on Quote {
  bool get hasSourceAndUri => source.isNotNull && sourceUri.isNotNull;

  bool get hasSource => source is String && source != '';

  bool get hasSourceUri => sourceUri.isNotNull;

  Iterable<int> get tagsId =>
      tags?.split(idSeparatorChar).map(int.tryParse).nonNulls ?? const <int>[];

  String shareableFormatOf(BuildContext context) => '''
${AppLocalizations.of(context)!.quoteShareHeader}
"$content"
\u2014 $author${source.isNotNullOrBlank ? ", $source" : ''}.
${sourceUri.isNotNullOrBlank ? '\n${AppLocalizations.of(context)!.quoteShareSeeMore(sourceUri!)}' : ''}
'''
      .trim();

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

  String createdAtLocaleMessageOf(BuildContext context) => timeago
      .format(createdAt!, locale: Localizations.localeOf(context).languageCode);
}
