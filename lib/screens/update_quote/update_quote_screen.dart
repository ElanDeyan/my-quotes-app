import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/my_quotes/_no_database_connection_message.dart';
import 'package:my_quotes/screens/update_quote/update_quote_form.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/shared/actions/tags/create_tag.dart';
import 'package:my_quotes/shared/widgets/an_error_occurred_message.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_skeleton.dart';
import 'package:my_quotes/shared/widgets/form/quote_not_found_with_id_message.dart';

final class UpdateQuoteScreen extends StatelessWidget {
  const UpdateQuoteScreen({
    required this.quoteId,
    super.key,
  });

  final int quoteId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.appLocalizations.editQuoteTitle),
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
      body: FutureBuilder(
        future: serviceLocator<AppRepository>().getQuoteById(quoteId),
        builder: (context, snapshot) {
          final connectionState = snapshot.connectionState;
          final hasError = snapshot.hasError;
          final hasData = snapshot.hasData;

          final data = snapshot.data;

          return switch ((connectionState, hasError, hasData)) {
            (ConnectionState.done, _, true) when data == null =>
              QuoteNotFoundWithIdMessage(quoteId: quoteId),
            (ConnectionState.done, _, true) when data != null =>
              UpdateQuoteForm(quote: data),
            (ConnectionState.waiting, _, _) =>
              const QuoteFormSkeleton(key: Key('quote_form_skeleton')),
            (ConnectionState.none, _, _) => const NoDatabaseConnectionMessage(
                key: Key('no_database_connection_message'),
              ),
            _ => const AnErrorOccurredMessage(),
          };
        },
      ),
    );
  }
}
