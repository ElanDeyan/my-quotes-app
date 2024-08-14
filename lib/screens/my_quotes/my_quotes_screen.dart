import 'package:flutter/material.dart';
import 'package:my_quotes/main.dart';
import 'package:my_quotes/screens/my_quotes/_no_database_connection_message.dart';
import 'package:my_quotes/screens/my_quotes/_no_quotes_added_yet.dart';
import 'package:my_quotes/screens/my_quotes/_quotes_list_error.dart';
import 'package:my_quotes/screens/my_quotes/_quotes_list_view.dart';
import 'package:my_quotes/screens/my_quotes/_quotes_list_view_skeleton.dart';

final class MyQuotesScreen extends StatelessWidget {
  const MyQuotesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseLocator.allQuotesStream,
      builder: (context, snapshot) {
        final connectionState = snapshot.connectionState;
        final hasError = snapshot.hasError;
        final hasData = snapshot.hasData;

        final data = snapshot.data;

        return switch ((connectionState, hasError, hasData)) {
          (ConnectionState.none, _, _) => const NoDatabaseConnectionMessage(),
          (ConnectionState.waiting, _, _) => const QuotesListViewSkeleton(),
          (ConnectionState.active || ConnectionState.done, _, true)
              when data != null && data.isEmpty =>
            const NoQuotesAddedYet(),
          (ConnectionState.active || ConnectionState.done, _, true)
              when data != null && data.isNotEmpty =>
            QuotesListView(data: data.reversed.toList()),
          _ => const QuotesListError()
        };
      },
    );
  }
}
