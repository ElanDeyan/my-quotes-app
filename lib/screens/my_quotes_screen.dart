import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/screens/quote_screen.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_pro/shimmer_pro.dart';

final class MyQuotesScreen extends StatelessWidget {
  const MyQuotesScreen({
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

          switch (connectionState) {
            case ConnectionState.none:
              return Text(
                'No database found',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              );
            case ConnectionState.active || ConnectionState.waiting:
              final isDarkTheme =
                  Theme.of(context).brightness == Brightness.dark;
              final parentWidth = MediaQuery.of(context).size.width;

              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var i = 0; i < 10; i++)
                        ShimmerPro.sized(
                          light: isDarkTheme ? ShimmerProLight.lighter : null,
                          scaffoldBackgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          height: 50,
                          width: parentWidth,
                        ),
                    ],
                  ),
                ),
              );
            case ConnectionState.done:
              final data = snapshot.data!;
              if (data case <Quote>[]) {
                return const Center(
                  child: Text("You don't have any quotes yet"),
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) => ListTile(
                  iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  title: Text(
                    data[index].content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    data[index].author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => showQuoteInfoDialog(context, data[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        icon: const Icon(Icons.warning),
                        title: const Text('Are you sure?'),
                        content: const Text("This can't be undone."),
                        actions: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.resolveWith(
                                (states) => Theme.of(context)
                                    .colorScheme
                                    .errorContainer,
                              ),
                            ),
                            onPressed: () {
                              database.removeQuote(data[index].id!);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
