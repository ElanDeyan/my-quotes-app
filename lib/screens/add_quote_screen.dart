import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_quotes/shared/quote_form_mixin.dart';
import 'package:my_quotes/shared/tags/create_tag.dart';

final class AddQuoteScreen extends StatelessWidget {
  const AddQuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
        actions: [
          IconButton(
            onPressed: () => createTag(context),
            icon: const Icon(Icons.new_label),
            tooltip: 'Create tag',
          ),
        ],
      ),
      body: AddQuoteForm(),
    );
  }
}

final class AddQuoteForm extends StatelessWidget with QuoteFormMixin {
  AddQuoteForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FormBuilder(
              key: formKey,
              onChanged: formKey.currentState?.validate,
              autovalidateMode: AutovalidateMode.always,
              child: quoteFormBody(context),
            ),
          ],
        ),
      ),
    );
  }
}
