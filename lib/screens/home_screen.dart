import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

final class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  static const screenName = 'Home';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<DatabaseProvider>(
        builder: (context, database, child) => FutureBuilder(
          future: database.randomQuote,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Card(
                child: switch (snapshot.data) {
                  Quote(
                    id: final id,
                    content: final content,
                    author: final author,
                    createdAt: final createdAt
                  ) =>
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Id: $id'),
                          Text(author),
                          Text(content),
                          Text('Created at: ${createdAt!.toLocal()}'),
                          ElevatedButton(
                            onPressed: () => context.goNamed(
                              'update',
                              pathParameters: {'id': '${id!}'},
                            ),
                            child: const Text('Update'),
                          ),
                        ],
                      ),
                    ),
                  null => const Text('No quote available')
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
