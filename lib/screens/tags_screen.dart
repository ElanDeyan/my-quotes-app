import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/search/search_tag_delegate.dart';
import 'package:my_quotes/shared/create_tag.dart';
import 'package:my_quotes/shared/show_tag_search.dart';
import 'package:my_quotes/shared/tag_actions.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

class TagsScreen extends StatelessWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () =>
                showTagSearch(context, SearchTagDelegate(context: context)),
          ),
        ],
        leading: BackButton(
          onPressed: () => context.canPop()
              ? context.pop(context)
              : context.pushNamed(myQuotesNavigationKey),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createTag(context),
        child: const Icon(Icons.new_label),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Consumer<DatabaseProvider>(
          builder: (context, database, child) => FutureBuilder(
            future: database.allTags,
            builder: (context, snapshot) {
              return switch (snapshot.connectionState) {
                ConnectionState.none => const Center(
                    child: Text('No database connection'),
                  ),
                ConnectionState.active ||
                ConnectionState.waiting =>
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ConnectionState.done => snapshot.hasError
                    ? const Center(
                        child: Text('Error'),
                      )
                    : _tagsList(context, snapshot.data!),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget _tagsList(BuildContext context, List<Tag> tags) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: tags.length,
      padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
      prototypeItem: ListTile(
        title: const Text('Tag name'),
        trailing: PopupMenuButton<Tag>(
          itemBuilder: (context) => [
            const PopupMenuItem<Tag>(
              value: Tag(name: 'name'),
              child: Text('Action'),
            ),
          ],
        ),
      ),
      itemBuilder: (context, index) => ListTile(
        title: Text(tags[index].name),
        onTap: () => context.goNamed(
          quoteWithTagNavigationKey,
          pathParameters: {
            'tagId': '${tags[index].id!}',
          },
        ),
        trailing: PopupMenuButton(
          tooltip: 'Actions',
          itemBuilder: (context) =>
              TagActions.popupMenuItems(context, tags[index]),
        ),
      ),
    );
  }
}
