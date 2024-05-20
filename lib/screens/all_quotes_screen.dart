import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

final class AllQuotesScreen extends StatelessWidget {
  const AllQuotesScreen({
    super.key,
  });

  static const screenName = 'All quotes';

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) => FutureBuilder(
        future: database.allQuotes,
        builder: (context, snapshot) {
          final connectionState = snapshot.connectionState;

          if (connectionState == ConnectionState.done && snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                title: Text(data[index].content),
                subtitle: Text(data[index].author),
                onTap: () => context.goNamed(
                  'quote',
                  pathParameters: {"id": "${data[index].id}"},
                ),
                trailing: IconButton(
                  onPressed: () => database.removeQuote(data[index].id!),
                  icon: const Icon(Icons.delete_forever),
                ),
              ),
              itemCount: data.length,
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
