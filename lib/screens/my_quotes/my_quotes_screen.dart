import 'package:flutter/material.dart';
import 'package:my_quotes/screens/my_quotes/_no_database_connection_message.dart';
import 'package:my_quotes/screens/my_quotes/_no_quotes_added_yet.dart';
import 'package:my_quotes/screens/my_quotes/_quotes_list_error.dart';
import 'package:my_quotes/screens/my_quotes/_quotes_list_view.dart';
import 'package:my_quotes/screens/my_quotes/_waiting_for_quotes_skeleton.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

final class MyQuotesScreen extends StatelessWidget {
  const MyQuotesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) => FutureBuilder(
        future: database.allQuotes,
        builder: (context, snapshot) {
          final connectionState = snapshot.connectionState;
          final hasError = snapshot.hasError;
          final hasData = snapshot.hasData;

          return switch ((connectionState, hasError, hasData)) {
            (ConnectionState.none, _, _) => const NoDatabaseConnectionMessage(),
            (ConnectionState.active || ConnectionState.waiting, _, _) =>
              const WaitingForQuotesSkeleton(),
            (ConnectionState.done, _, true) when snapshot.data!.isEmpty =>
              const NoQuotesAddedYet(),
            (ConnectionState.done, _, true) when snapshot.data!.isNotEmpty =>
              QuotesListView(data: snapshot.data!),
            _ => const QuotesListError()
          };
        },
      ),
    );
  }
}
