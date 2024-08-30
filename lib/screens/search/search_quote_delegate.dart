import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/fuzzy_search_extension.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/search/search_quote_results.dart';
import 'package:my_quotes/states/service_locator.dart';

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
      await serviceLocator<AppRepository>().allQuotes;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: context.appLocalizations.navigationSearchClear,
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear_outlined),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: context.appLocalizations.navigationBack,
      onPressed: () => context.canPop()
          ? context.pop()
          : context.pushNamed(myQuotesNavigationKey),
      icon: const Icon(Icons.arrow_back_outlined),
    );
  }

  @override
  Widget buildResults(BuildContext context) => FutureBuilder(
        future: allQuotes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(context.appLocalizations.noQuotesAddedYet),
                );
              }
              final searchResults = snapshot.data!
                  .fuzzyExtractAllSorted(
                    query: query,
                    cutoff: 50,
                    getter: (quote) => quote.dataForQuery,
                  )
                  .map((result) => result.choice);
              if (searchResults.isEmpty) {
                return Center(
                  child: Text(context.appLocalizations.noResultsFound),
                );
              }
              return SearchQuoteResults(searchResults: searchResults.toList());
            } else {
              return Center(
                child: Text(snapshot.error.toString()),
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
  Widget buildSuggestions(BuildContext context) => query.isBlank
      ? const SizedBox.shrink()
      : FutureBuilder(
          future: allQuotes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasError) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(context.appLocalizations.noQuotesAddedYet),
                  );
                }

                final searchResults = snapshot.data!
                    .fuzzyExtractAllSorted(
                      query: query,
                      cutoff: 50,
                      getter: (quote) => quote.dataForQuery,
                    )
                    .map((result) => result.choice)
                    .toList();

                if (searchResults.isEmpty) {
                  return Center(
                    child: Text(context.appLocalizations.noResultsFound),
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
                      context.pushNamed(
                        quoteByIdNavigationKey,
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
