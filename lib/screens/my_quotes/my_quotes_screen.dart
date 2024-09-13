import 'package:flutter/material.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/screens/my_quotes/_no_database_connection_message.dart';
import 'package:my_quotes/screens/my_quotes/_no_quotes_added_yet.dart';
import 'package:my_quotes/screens/my_quotes/_quotes_list_error.dart';
import 'package:my_quotes/screens/my_quotes/_quotes_list_view_skeleton.dart';
import 'package:my_quotes/screens/my_quotes/quotes_list_view_container.dart';
import 'package:my_quotes/services/service_locator.dart';

final class MyQuotesScreen extends StatelessWidget {
  const MyQuotesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: StreamBuilder(
        stream: serviceLocator<AppRepository>().allQuotesStream,
        builder: (context, snapshot) {
          final connectionState = snapshot.connectionState;
          final hasError = snapshot.hasError;
          final hasData = snapshot.hasData;

          final data = snapshot.data;

          return switch ((connectionState, hasError, hasData)) {
            (ConnectionState.none, _, _) => const NoDatabaseConnectionMessage(),
            (ConnectionState.waiting, _, _) => const QuotesListViewSkeleton(
                key: Key('quotes_list_view_container_skeleton'),
              ),
            (ConnectionState.active || ConnectionState.done, _, true)
                when data != null && data.isEmpty =>
              const NoQuotesAddedYet(),
            (ConnectionState.active || ConnectionState.done, _, true)
                when data != null && data.isNotEmpty =>
              QuotesListViewContainer(
                key: const Key('quotes_list_view_container'),
                quotes: data,
              ),
            _ => const QuotesListError()
          };
        },
      ),
    );
  }
}
