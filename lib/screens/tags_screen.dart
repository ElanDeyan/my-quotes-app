import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/create_tag.dart';
import 'package:my_quotes/shared/delete_tag.dart';
import 'package:my_quotes/shared/update_tag.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

class TagsScreen extends StatelessWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
        leading: BackButton(
          onPressed: () => context.canPop()
              ? context.pop(context)
              : context.pushNamed('mainScreen'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createTag(context),
        child: const Icon(Icons.new_label),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                    : _tagsList(snapshot.data!),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget _tagsList(List<Tag> tags) {
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
        trailing: Consumer<DatabaseProvider>(
          builder: (context, database, child) => PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem<Tag>(
                value: tags[index],
                onTap: () => updateTag(context, tags[index]),
                child: const Text('Update'),
              ),
              PopupMenuItem<Tag>(
                value: tags[index],
                onTap: () => deleteTag(context, tags[index]),
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
