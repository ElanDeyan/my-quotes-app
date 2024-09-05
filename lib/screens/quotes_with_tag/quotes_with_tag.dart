import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/repository/interfaces/app_repository.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/my_quotes/_no_database_connection_message.dart';
import 'package:my_quotes/screens/quotes_with_tag/quotes_with_tag_results.dart';
import 'package:my_quotes/shared/widgets/an_error_occurred_message.dart';
import 'package:my_quotes/shared/widgets/no_quotes_with_tag.dart';
import 'package:my_quotes/shared/widgets/quotes_search_result_skeleton.dart';
import 'package:my_quotes/services/service_locator.dart';

class QuotesWithTag extends StatelessWidget {
  const QuotesWithTag({super.key, required this.tagId});

  final int tagId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.appLocalizations.quotesWithThisTag),
        leading: BackButton(
          onPressed: () => context.canPop()
              ? context.pop()
              : context.goNamed(myQuotesNavigationKey),
        ),
      ),
      body: RepaintBoundary(
        child: StreamBuilder(
          stream:
              serviceLocator<AppRepository>().getQuotesWithTagIdStream(tagId),
          builder: (context, snapshot) {
            final connectionState = snapshot.connectionState;
            final hasError = snapshot.hasError;
            final hasData = snapshot.hasData;

            final data = snapshot.data;

            return switch ((connectionState, hasError, hasData)) {
              (ConnectionState.none, _, _) =>
                const NoDatabaseConnectionMessage(),
              (ConnectionState.waiting, _, _) =>
                const QuotesSearchResultSkeleton(),
              (ConnectionState.active || ConnectionState.done, _, true)
                  when data != null && data.isEmpty =>
                const NoQuotesWithTag(),
              (ConnectionState.active || ConnectionState.done, _, true)
                  when data != null && data.isNotEmpty =>
                QuotesWithTagResults(quotes: data),
              _ => const AnErrorOccurredMessage(),
            };
          },
        ),
      ),
    );
  }
}
