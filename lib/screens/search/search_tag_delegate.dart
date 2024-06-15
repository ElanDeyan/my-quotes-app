import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/search/search_tag_results.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

final class SearchTagDelegate extends SearchDelegate<Tag> {
  SearchTagDelegate({
    super.searchFieldLabel,
    super.keyboardType,
    super.searchFieldDecorationTheme,
    super.searchFieldStyle,
    super.textInputAction,
    required this.context,
  });

  final BuildContext context;

  Future<List<Tag>> get allTags async =>
      await context.read<DatabaseProvider>().allTags;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: AppLocalizations.of(context)!.navigationSearchClear,
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
      tooltip: AppLocalizations.of(context)!.navigationBack,
      onPressed: () => context.canPop()
          ? context.pop()
          : context.pushNamed(tagsNavigationKey),
      icon: const Icon(Icons.arrow_back_outlined),
    );
  }

  @override
  Widget buildResults(BuildContext context) => FutureBuilder(
        future: allTags,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No tags found'),
                );
              }
              final searchResults = snapshot.data!
                  .where(
                    (tag) =>
                        tag.name.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList();
              if (searchResults.isEmpty) {
                return const Center(
                  child: Text('No results found'),
                );
              }
              return SearchTagResults(searchResults: searchResults);
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
          future: allTags,
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
                      (tag) =>
                          tag.name.toLowerCase().contains(query.toLowerCase()),
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
                      searchResults[index].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      context.pushNamed(
                        quoteWithTagNavigationKey,
                        pathParameters: {
                          'tagId': '${searchResults[index].id!}',
                        },
                      );
                    },
                  ),
                );
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
}
