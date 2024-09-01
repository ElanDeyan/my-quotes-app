import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/my_quotes/_no_database_connection_message.dart';
import 'package:my_quotes/screens/quote_single/quote_card_with_extra_data.dart';
import 'package:my_quotes/shared/widgets/an_error_occurred_message.dart';
import 'package:my_quotes/shared/widgets/form/quote_not_found_with_id_message.dart';
import 'package:my_quotes/shared/widgets/quote_card_skeleton.dart';
import 'package:my_quotes/states/service_locator.dart';

final class QuoteScreen extends StatelessWidget {
  const QuoteScreen({
    super.key,
    required this.quoteId,
  });

  final int quoteId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.appLocalizations.quoteInfo),
        leading: BackButton(
          onPressed: () => context.canPop()
              ? context.pop()
              : context.pushNamed(myQuotesNavigationKey),
        ),
      ),
      body: QuoteScreenBody(quoteId: quoteId),
    );
  }
}

class QuoteScreenBody extends StatelessWidget {
  const QuoteScreenBody({
    super.key,
    required this.quoteId,
  });

  final int quoteId;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return Center(
      child: StreamBuilder(
        stream: serviceLocator<AppRepository>().getQuoteByIdStream(quoteId),
        builder: (context, snapshot) {
          final connectionState = snapshot.connectionState;
          final hasError = snapshot.hasError;
          final hasData = snapshot.hasData;
          final data = snapshot.data;

          return switch ((connectionState, hasError, hasData)) {
            (ConnectionState.none, _, _) => const NoDatabaseConnectionMessage(),
            (ConnectionState.waiting, _, _) =>
              const QuoteCardSkeleton(key: Key('quote_card_skeleton')),
            (ConnectionState.active || ConnectionState.done, _, true)
                when data == null =>
              QuoteNotFoundWithIdMessage(quoteId: quoteId),
            (ConnectionState.active || ConnectionState.done, _, true)
                when data != null =>
              QuoteCardWithExtraData(
                quote: data,
                appLocalizations: appLocalizations,
              ),
            _ => const AnErrorOccurredMessage(),
          };
        },
      ),
    );
  }
}
