import 'dart:convert';

import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/shared/actions/quotes/quote_actions.dart';
import 'package:timeago/timeago.dart' as timeago;

extension QuoteExtension on Quote {
  bool get hasSourceAndUri =>
      source.isNotNullOrBlank && sourceUri.isNotNullOrBlank;

  bool get hasSource => source.isNotNullOrBlank;

  bool get hasSourceUri => sourceUri.isNotNullOrBlank;

  Iterable<int> get tagsId =>
      tags?.split(idSeparatorChar).map(int.tryParse).nonNulls ?? const <int>[];

  String shareableFormatOf(AppLocalizations appLocalizations) {
    final stringBuffer = StringBuffer()
      ..writeAll(
        [
          appLocalizations.quoteShareHeader,
          '"$content"',
          '\u2014 $author${source.isNotNullOrBlank ? ", $source" : ''}.',
          if (sourceUri.isNotNullOrBlank)
            appLocalizations.quoteShareSeeMore(sourceUri!),
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
    final stringBuffer = StringBuffer()
      ..writeAll(
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

  String createdAtLocaleMessageOf(Locale locale) =>
      timeago.format(createdAt!, locale: locale.languageCode);

  Future<String> toShareableJsonString(
    AppRepository appRepository,
  ) async {
    final tagsName =
        (await appRepository.getTagsByIds(tagsId)).map((tag) => tag.name);

    return jsonEncode(<String, Object?>{
      'content': content,
      'author': author,
      'source': source.isNotNullOrBlank ? source : null,
      'sourceUri': sourceUri.isNotNullOrBlank ? sourceUri : null,
      'isFavorite': isFavorite,
      'tags': tagsName.toList(),
    });
  }
}
