import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/shared/actions/tags/tag_actions.dart';

class TagsListView extends StatelessWidget {
  const TagsListView({
    super.key,
    required this.tags,
  });

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
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
          tooltip: context.appLocalizations.tagActionsPopupButtonTooltip,
          itemBuilder: (context) =>
              TagActions.popupMenuItems(context, tags[index]),
        ),
      ),
    );
  }
}
