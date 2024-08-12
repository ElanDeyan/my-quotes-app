import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/screens/add_quote_from_file/add_quote_from_file_form.dart';
import 'package:my_quotes/shared/actions/tags/create_tag.dart';

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
        title: Text(context.appLocalizations.addQuoteTitle),
        actions: [
          IconButton(
            onPressed: () => createTag(context),
            icon: const Icon(Icons.new_label),
            tooltip: context.appLocalizations.createTag,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: AddQuoteFromFileForm(
          tagsNamesFromFile: tags.toSet(),
          quoteFromFile: quote,
        ),
      ),
    );
  }
}
