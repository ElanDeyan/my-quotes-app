import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_pro/shimmer_pro.dart';

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
                child: ShimmerPro.generated(
                  light: isDarkTheme ? ShimmerProLight.lighter : null,
                  scaffoldBackgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var i = 0; i < 10; i++)
                          ShimmerPro.sized(
                            scaffoldBackgroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            height: 50,
                            width: parentWidth,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            case ConnectionState.done:
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
          }
        },
      ),
    );
  }
}
