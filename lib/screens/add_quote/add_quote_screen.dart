import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/add_quote/add_quote_form.dart';
import 'package:my_quotes/shared/actions/tags/create_tag.dart';

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
      body: const AddQuoteForm(
        key: Key('add_quote_form'),
      ),
    );
  }
}
