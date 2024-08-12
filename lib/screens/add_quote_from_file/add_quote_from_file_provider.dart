import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/screens/add_quote_from_file/add_quote_from_file_form_builder.dart';
import 'package:my_quotes/shared/widgets/an_error_occurred_message.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_skeleton.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

class AddQuoteFromFileProvider extends StatelessWidget {
  const AddQuoteFromFileProvider({
    super.key,
    required this.quote,
    required this.tags,
  });

  final Quote quote;
  final List<String> tags;

  Future<List<String>> _updateTagsIds(
    BuildContext context,
    List<String> tags,
  ) async {
    if (tags.isEmpty) return <String>[];

    final tagsIds = <String>[];

    final database = Provider.of<DatabaseProvider>(context, listen: false);
    final allTags = await database.allTags;

    tagsIds.addAll(
      allTags
          .where((tag) => tags.contains(tag.name))
          .map((tag) => tag.id.toString()),
    );

    final allTagsNames = allTags.map((tag) => tag.name);
    final missingTags =
        tags.where((tagName) => !allTagsNames.contains(tagName));

    for (final missingTag in missingTags) {
      final newId = await database.createTag(missingTag);
      tagsIds.add(newId.toString());
    }

    return tagsIds;
  }

  Map<String, Object?> get quoteAsJson => quote.toJson();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _updateTagsIds(context, tags),
      builder: (context, snapshot) {
        final connectionState = snapshot.connectionState;
        final hasError = snapshot.hasError;
        final hasData = snapshot.hasData;

        final data = snapshot.data;

        return switch ((connectionState, hasError, hasData)) {
          (ConnectionState.waiting, _, _) => const QuoteFormSkeleton(),
          (ConnectionState.done, _, true) => AddQuoteFromFileFormBuilder(
              tagsIds: data!,
              quoteAsJson: quoteAsJson,
            ),
          _ => const AnErrorOccurredMessage(),
        };
      },
    );
  }
}
