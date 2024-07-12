import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/search/search_tag_delegate.dart';
import 'package:my_quotes/shared/actions/tags/create_tag.dart';
import 'package:my_quotes/shared/actions/tags/show_tag_search.dart';
import 'package:my_quotes/shared/actions/tags/tag_actions.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

class TagsScreen extends StatelessWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tags),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: AppLocalizations.of(context)!.navigationSearchTag,
            onPressed: () => showTagSearch(
              context,
              SearchTagDelegate(
                context: context,
                keyboardType: TextInputType.text,
                searchFieldLabel:
                    AppLocalizations.of(context)!.navigationSearchLabel,
              ),
            ),
          ),
        ],
        leading: IconButton(
          tooltip: AppLocalizations.of(context)!.navigationBack,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => context.canPop()
              ? context.pop(context)
              : context.pushNamed(myQuotesNavigationKey),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: AppLocalizations.of(context)!.navigationAddTag,
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
                ConnectionState.none => Center(
                    child: Text(
                      AppLocalizations.of(context)!.noDatabaseConnectionMessage,
                    ),
                  ),
                ConnectionState.active ||
                ConnectionState.waiting =>
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ConnectionState.done => snapshot.hasError
                    ? Center(
                        child:
                            Text(AppLocalizations.of(context)!.errorOccurred),
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
      padding: const EdgeInsets.only(
        bottom: kBottomNavigationBarHeight + kFloatingActionButtonMargin,
      ),
      prototypeItem: ListTile(
        title: const Text('Tag name'),
        trailing: PopupMenuButton<Tag>(
          itemBuilder: (context) => [
            const PopupMenuItem<Tag>(
              child: Text('Action'),
            ),
          ],
        ),
      ),
      itemBuilder: (context, index) => ListTile(
        title: Text(tags[index].name),
        onTap: () => context.pushNamed(
          quoteWithTagNavigationKey,
          pathParameters: {
            'tagId': '${tags[index].id}',
          },
        ),
        trailing: PopupMenuButton(
          tooltip: AppLocalizations.of(context)!.tagActionsPopupButtonTooltip,
          itemBuilder: (context) =>
              TagActions.popupMenuItems(context, tags[index]),
        ),
      ),
    );
  }
}
