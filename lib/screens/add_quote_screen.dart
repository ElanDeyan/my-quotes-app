import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/quote_form_mixin.dart';

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

Future<void> showAddQuoteModal(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: AddQuoteForm(),
    ),
  );
}

final class AddQuoteForm extends StatefulWidget {
  const AddQuoteForm({super.key});

  @override
  State<AddQuoteForm> createState() => _AddQuoteFormState();
}

class _AddQuoteFormState extends State<AddQuoteForm> with QuoteFormMixin {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Add',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          FormBuilder(
            key: formKey,
            onChanged: formKey.currentState?.validate,
            autovalidateMode: AutovalidateMode.always,
            child: quoteFormBody(),
          ),
        ],
      ),
    );
  }
}
