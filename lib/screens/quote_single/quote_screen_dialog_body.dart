import 'package:flutter/material.dart';
import 'package:my_quotes/repository/interfaces/app_repository.dart';
import 'package:my_quotes/screens/my_quotes/_no_database_connection_message.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/shared/widgets/an_error_occurred_message.dart';
import 'package:my_quotes/shared/widgets/no_quote_with_id_message.dart';
import 'package:my_quotes/shared/widgets/quote_data_list_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuoteScreenDialogBody extends StatelessWidget {
  const QuoteScreenDialogBody({
    super.key,
    required this.quoteId,
  });

  final int quoteId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: StreamBuilder(
          stream: serviceLocator<AppRepository>().getQuoteByIdStream(quoteId),
          builder: (context, snapshot) {
            final connectionState = snapshot.connectionState;
            final hasError = snapshot.hasError;
            final hasData = snapshot.hasData;

            final data = snapshot.data;

            return switch ((connectionState, hasError, hasData)) {
              (ConnectionState.none, _, _) => const NoDatabaseConnectionMessage(
                  key: Key('no_database_connection_message'),
                ),
              (ConnectionState.waiting, _, _) => Skeletonizer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      5,
                      (index) => const Bone.text(),
                    ),
                  ),
                ),
              (ConnectionState.active || ConnectionState.done, _, true)
                  when data == null =>
                NoQuoteWithIdMessage(quoteId: quoteId),
              (ConnectionState.active || ConnectionState.done, _, true)
                  when data != null =>
                QuoteDataListView(
                  quote: data,
                  appRepository: serviceLocator<AppRepository>(),
                ),
              _ => const AnErrorOccurredMessage(),
            };
          },
        ),
      ),
    );
  }
}
