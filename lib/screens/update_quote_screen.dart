import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/quote_form_mixin.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

final class UpdateQuoteScreen extends StatelessWidget {
  const UpdateQuoteScreen({
    super.key,
    required this.quoteId,
  });

  final int quoteId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: UpdateQuoteScreenBody(quoteId: quoteId),
      ),
    );
  }
}

Future<void> showUpdateQuoteDialog(BuildContext context, Quote quote) {
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog.fullscreen(
      child: UpdateQuoteScreen(quoteId: quote.id!),
    ),
  );
}

class UpdateQuoteScreenBody extends StatelessWidget {
  const UpdateQuoteScreenBody({
    super.key,
    required this.quoteId,
  });

  final int quoteId;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder(
            future: database.getQuoteById(quoteId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final maybeQuote = snapshot.data;
                if (maybeQuote == null) {
                  return Text(
                    'Quote not found with this id: $quoteId',
                  );
                } else {
                  return UpdateQuoteForm(quote: maybeQuote);
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class UpdateQuoteForm extends StatelessWidget with QuoteFormMixin {
  UpdateQuoteForm({
    super.key,
    required this.quote,
  });

  final Quote quote;

  Map<String, dynamic> get quoteAsJson => quote.toJson()
    ..update(
      'tags',
      (value) => switch (value) {
        final String tags => tags.split(','),
        _ => <String>[],
      },
      ifAbsent: () => <String>[],
    );

  @override
  bool get isUpdateForm => true;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      onChanged: formKey.currentState?.validate,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: quoteAsJson,
      child: quoteFormBody(context, quoteForUpdate: quote),
    );
  }
}
