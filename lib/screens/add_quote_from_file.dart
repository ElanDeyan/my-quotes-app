import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/constants/enums/form_types.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/actions/tags/create_tag.dart';
import 'package:my_quotes/shared/widgets/quote_form_mixin.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

final class AddQuoteFromFileScreen extends StatelessWidget {
  const AddQuoteFromFileScreen({
    super.key,
    required this.quote,
    required this.tags,
  });

  final Quote quote;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addQuoteTitle),
        actions: [
          IconButton(
            onPressed: () => createTag(context),
            icon: const Icon(Icons.new_label),
            tooltip: AppLocalizations.of(context)!.createTag,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: AddQuoteFromFileForm(quote: quote, tags: tags),
      ),
    );
  }
}

class AddQuoteFromFileForm extends StatefulWidget {
  const AddQuoteFromFileForm({
    super.key,
    required this.quote,
    required this.tags,
  });

  final Quote quote;
  final List<String> tags;

  @override
  State<AddQuoteFromFileForm> createState() => _AddQuoteFromFileFormState();
}

class _AddQuoteFromFileFormState extends State<AddQuoteFromFileForm>
    with QuoteFormMixin {
  late Future<List<String>> futureTagsIds;

  @override
  void initState() {
    super.initState();
    futureTagsIds = _updateTagsIds(widget.tags);
  }

  @override
  void dispose() {
    multipleTagSearchController
      ..clearAllPickedItems()
      ..clearSearchField();
    formKey.currentState?.reset();
    super.dispose();
  }

  Future<List<String>> _updateTagsIds(List<String> tags) async {
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

  Map<String, Object?> get quoteAsJson => widget.quote.toJson();

  @override
  FormTypes get formType => FormTypes.addFromFile;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureTagsIds,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          final tagsIdsAsString = snapshot.data!.join(idSeparatorChar);
          final updatedQuoteJson = quoteAsJson.map(
            (key, value) => key == 'tags'
                ? MapEntry(key, snapshot.data!)
                : MapEntry(key, value),
          );
          final updatedQuote = Quote.fromJson(
            updatedQuoteJson.map(
              (key, value) => key == 'tags'
                  ? MapEntry(key, tagsIdsAsString)
                  : MapEntry(key, value),
            ),
          );
          return FormBuilder(
            key: formKey,
            onChanged: formKey.currentState?.validate,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: updatedQuoteJson,
            child: quoteFormBody(
              context,
              quoteForUpdate: updatedQuote,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(AppLocalizations.of(context)!.errorOccurred),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
