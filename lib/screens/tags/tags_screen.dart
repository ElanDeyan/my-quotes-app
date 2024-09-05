import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/repository/interfaces/app_repository.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/my_quotes/_no_database_connection_message.dart';
import 'package:my_quotes/screens/search/search_tag_delegate.dart';
import 'package:my_quotes/screens/tags/tags_list_view.dart';
import 'package:my_quotes/screens/tags/tags_list_view_skeleton.dart';
import 'package:my_quotes/shared/actions/tags/create_tag.dart';
import 'package:my_quotes/shared/actions/tags/show_tag_search.dart';
import 'package:my_quotes/shared/widgets/an_error_occurred_message.dart';
import 'package:my_quotes/shared/widgets/no_tags_added_yet_message.dart';
import 'package:my_quotes/states/service_locator.dart';

class TagsScreen extends StatelessWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.appLocalizations.tags),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: context.appLocalizations.navigationSearchTag,
            onPressed: () => showTagSearch(
              context,
              SearchTagDelegate(
                context: context,
                keyboardType: TextInputType.text,
                searchFieldLabel:
                    context.appLocalizations.navigationSearchLabel,
              ),
            ),
          ),
        ],
        leading: IconButton(
          tooltip: context.appLocalizations.navigationBack,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => context.canPop()
              ? context.pop(context)
              : context.pushNamed(myQuotesNavigationKey),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: context.appLocalizations.navigationAddTag,
        onPressed: () => createTag(context),
        child: const Icon(Icons.new_label),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: StreamBuilder(
          stream: serviceLocator<AppRepository>().allTagsStream,
          builder: (context, snapshot) {
            final connectionState = snapshot.connectionState;
            final hasError = snapshot.hasError;
            final hasData = snapshot.hasData;

            final data = snapshot.data;

            return switch ((connectionState, hasError, hasData)) {
              (ConnectionState.none, _, _) => const NoDatabaseConnectionMessage(
                  key: Key('no_database_connection_message'),
                ),
              (ConnectionState.waiting, _, _) => const TagsListViewSkeleton(),
              (ConnectionState.active || ConnectionState.done, _, true)
                  when data!.isNotEmpty =>
                TagsListView(tags: data),
              (ConnectionState.active || ConnectionState.done, _, true)
                  when data!.isEmpty =>
                const NoTagsAddedYetMessage(),
              _ => const AnErrorOccurredMessage()
            };
          },
        ),
      ),
    );
  }
}
