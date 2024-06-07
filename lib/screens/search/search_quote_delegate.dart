import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

final class SearchQuoteDelegate extends SearchDelegate<Quote> {
  SearchQuoteDelegate({
    super.searchFieldLabel,
    super.keyboardType,
    super.searchFieldDecorationTheme,
    super.searchFieldStyle,
    super.textInputAction,
    required this.context,
  });

  final BuildContext context;

  Future<List<Quote>> get allQuotes async =>
      await context.read<DatabaseProvider>().allQuotes;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) => FutureBuilder(
        future: allQuotes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No quotes found'),
                );
              }
              final searchResults = snapshot.data!
                  .where(
                    (quote) => quote.dataForQuery
                        .toLowerCase()
                        .contains(query.toLowerCase()),
                  )
                  .toList();
              if (searchResults.isEmpty) {
                return const Center(
                  child: Text('No results found'),
                );
              }
              return ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    searchResults[index].content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    searchResults[index].author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    context.goNamed(
                      'quote',
                      pathParameters: {'id': '${searchResults[index].id}'},
                    );
                  },
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const SizedBox.shrink();
        },
      );

  @override
  Widget buildSuggestions(BuildContext context) => FutureBuilder(
        future: allQuotes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No quotes found'),
                );
              }

              final searchResults = snapshot.data!
                  .where(
                    (quote) => quote.dataForQuery
                        .toLowerCase()
                        .contains(query.toLowerCase()),
                  )
                  .toList();

              if (searchResults.isEmpty) {
                return const Center(
                  child: Text('No results found'),
                );
              }

              return ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    searchResults[index].content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    searchResults[index].author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    context.goNamed(
                      'quote',
                      pathParameters: {'id': '${searchResults[index].id}'},
                    );
                  },
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const SizedBox.shrink();
        },
      );
}
