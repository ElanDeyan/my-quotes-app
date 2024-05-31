import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/quote_form_mixin.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
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
        actions: [
          IconButton(
            onPressed: () => context.goNamed('mainScreen'),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: UpdateQuoteScreenBody(quoteId: quoteId),
    );
  }
}

Future<void> showUpdateQuoteModal(BuildContext context, Quote quote) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => UpdateQuoteScreenBody(quoteId: quote.id!),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Update',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 5,
            ),
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
      ),
    );
  }
}

class UpdateQuoteForm extends StatefulWidget {
  const UpdateQuoteForm({
    super.key,
    required this.quote,
  });

  final Quote quote;

  @override
  State<UpdateQuoteForm> createState() => _UpdateQuoteFormState();
}

class _UpdateQuoteFormState extends State<UpdateQuoteForm> with QuoteFormMixin {
  @override
  bool get isUpdateForm => true;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      onChanged: formKey.currentState?.validate,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: widget.quote.toJson()
        ..update(
          'tags',
          (value) => switch (value) {
            final String tags => tags.split(','),
            _ => <String>[],
          },
          ifAbsent: () => <String>[],
        ),
      child: quoteFormBody(quoteForUpdate: widget.quote),
    );
  }
}
