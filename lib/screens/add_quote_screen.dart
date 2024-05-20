import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

final class AddQuoteScreen extends StatelessWidget {
  const AddQuoteScreen({super.key});

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
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: AddQuoteForm(),
      ),
    );
  }
}

class AddQuoteForm extends StatefulWidget {
  const AddQuoteForm({super.key});

  @override
  State<AddQuoteForm> createState() => _AddQuoteFormState();
}

class _AddQuoteFormState extends State<AddQuoteForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  final urlPattern = RegExp(
    r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)',
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FormBuilder(
            key: _formKey,
            onChanged: _formKey.currentState?.validate,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  initialValue: 'Anonym',
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
                Consumer<DatabaseProvider>(
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

                      try {
                        final quoteToAdd = Quote.fromJson(formValueMapped);
                        scheduleMicrotask(() => database.addQuote(quoteToAdd));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Succesfully added!")),
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
          ),
        ],
      ),
    );
  }
}
