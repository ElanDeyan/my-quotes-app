import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/shared/actions/tags/create_tag.dart';
import 'package:my_quotes/shared/widgets/quote_form_mixin.dart';

final class AddQuoteScreen extends StatelessWidget {
  const AddQuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.appLocalizations.addQuoteTitle),
        leading: BackButton(
          onPressed: () => context.canPop()
              ? context.pop()
              : context.goNamed(homeNavigationKey),
        ),
        actions: [
          IconButton(
            onPressed: () => createTag(context),
            icon: const Icon(Icons.new_label),
            tooltip: context.appLocalizations.createTag,
          ),
        ],
      ),
      body: const AddQuoteForm(),
    );
  }
}

final class AddQuoteForm extends StatefulWidget {
  const AddQuoteForm({super.key});

  @override
  State<AddQuoteForm> createState() => _AddQuoteFormState();
}

class _AddQuoteFormState extends State<AddQuoteForm> with QuoteFormMixin {
  @override
  void dispose() {
    multipleTagSearchController
      ..clearAllPickedItems()
      ..clearSearchField();
    formKey.currentState?.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: FormBuilder(
          key: formKey,
          onChanged: formKey.currentState?.validate,
          autovalidateMode: AutovalidateMode.always,
          child: quoteFormBody(context),
        ),
      ),
    );
  }
}
