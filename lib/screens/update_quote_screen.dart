import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/states/database_notifier.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<DatabaseNotifier>(
                builder: (context, database, child) => FutureBuilder(
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
              ),
            ],
          ),
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

class _UpdateQuoteFormState extends State<UpdateQuoteForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  final urlPattern = RegExp(
    r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)',
  );

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      onChanged: _formKey.currentState?.validate,
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
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'content',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Content',
            ),
            maxLines: null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Can't be empty.";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          FormBuilderTextField(
            name: 'author',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Author',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Can't be empty.";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          FormBuilderTextField(
            name: 'source',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Source',
              helperText: 'Movie, book, event, place and etc',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FormBuilderTextField(
            name: 'sourceUri',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Source link',
              helperText: 'Link to the source',
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!urlPattern.hasMatch(value)) {
                  return 'Enter a valid link';
                }
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          FormBuilderCheckbox(
            name: 'isFavorite',
            title: const Text('Is favorite?'),
          ),
          const SizedBox(
            height: 10,
          ),
          FormBuilderFilterChip(
            name: 'tags',
            options: const [
              FormBuilderChipOption(value: 'jw'),
              FormBuilderChipOption(value: 'tech'),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Consumer<DatabaseNotifier>(
            builder: (context, database, child) => ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                _formKey.currentState!.saveAndValidate();

                final formValue = _formKey.currentState!.value;

                final formValueMapped = formValue.map(
                  (key, value) {
                    if (key == 'tags') {
                      final newValue = (value as List<String>).join(',');
                      return MapEntry(key, newValue);
                    } else {
                      return MapEntry(key, value);
                    }
                  },
                );

                formValueMapped.update(
                  'id',
                  (value) => value,
                  ifAbsent: () => widget.quote.id,
                );

                formValueMapped.update(
                  'createdAt',
                  (value) => value,
                  ifAbsent: () => widget.quote.createdAt,
                );

                try {
                  final quoteToUpdate = Quote.fromJson(formValueMapped);
                  scheduleMicrotask(() => database.updateQuote(quoteToUpdate));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Succesfully updated!")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Can't parse to Quote")),
                  );
                  rethrow;
                }

                context.goNamed('mainScreen');
              },
            ),
          ),
        ],
      ),
    );
  }
}
