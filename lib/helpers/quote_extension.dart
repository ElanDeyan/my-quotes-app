import 'dart:convert';

import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/actions/quotes/quote_actions.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

extension QuoteExtension on Quote {
  bool get hasSourceAndUri =>
      source.isNotNullOrBlank && sourceUri.isNotNullOrBlank;

  bool get hasSource => source.isNotNullOrBlank;

  bool get hasSourceUri => sourceUri.isNotNullOrBlank;

  Iterable<int> get tagsId =>
      tags?.split(idSeparatorChar).map(int.tryParse).nonNulls ?? const <int>[];

  String shareableFormatOf(BuildContext context) {
    final stringBuffer = StringBuffer();

    stringBuffer.writeAll(
      [
        AppLocalizations.of(context)!.quoteShareHeader,
        '"$content"',
        '\u2014 $author${source.isNotNullOrBlank ? ", $source" : ''}.',
        if (sourceUri.isNotNullOrBlank)
          AppLocalizations.of(context)!.quoteShareSeeMore(sourceUri!),
      ],
      '\n',
    );

    return stringBuffer.toString();
  }

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
        if (source.isNotNullOrBlank) source,
        if (sourceUri.isNotNullOrBlank) sourceUri,
      ],
      '\n',
    );

    return stringBuffer.toString();
  }

  String createdAtLocaleMessageOf(BuildContext context) => timeago
      .format(createdAt!, locale: Localizations.localeOf(context).languageCode);

  Future<List<String>> _getTagsName(BuildContext context) async {
    final database = Provider.of<DatabaseProvider>(context, listen: false);
    final tagsName =
        (await database.getTagsByIds(tagsId)).map((tag) => tag.name);

    return tagsName.toList();
  }

  Future<String> toShareableJsonString(BuildContext context) async {
    final tagsName = await _getTagsName(context);

    return jsonEncode(<String, Object?>{
      'content': content,
      'author': author,
      'source': source.isNotNullOrBlank ? source : null,
      'sourceUri': sourceUri.isNotNullOrBlank ? sourceUri : null,
      'isFavorite': isFavorite,
      'tags': tagsName,
    });
  }
}
