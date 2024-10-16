import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/shared/actions/tags/delete_tag.dart';
import 'package:my_quotes/shared/actions/tags/update_tag.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';

enum TagActions {
  edit(
    label: Text('Edit'),
    name: 'Edit',
    debugLabel: 'edit',
    icon: Icon(Icons.edit_outlined),
  ),
  delete(
    label: Text('Delete'),
    name: 'Delete',
    debugLabel: 'delete',
    icon: Icon(Icons.delete_outline),
  );

  const TagActions({
    required this.label,
    required this.debugLabel,
    required this.name,
    required this.icon,
  });

  final Widget label;
  final String debugLabel;
  final String name;
  final Icon icon;

  @override
  String toString() {
    return name;
  }

  static List<PopupMenuItem<Tag>> popupMenuItems(
    BuildContext context,
    Tag tag, {
    Iterable<TagActions> actions = TagActions.values,
  }) =>
      actions
          .map(
            (action) => PopupMenuItem<Tag>(
              value: tag,
              onTap: switch (action) {
                TagActions.edit => () => updateTag(context, tag),
                TagActions.delete => () => deleteTag(context, tag),
              },
              child: IconWithLabel(
                icon: action.icon,
                horizontalGap: 10,
                label: Text(
                  context.appLocalizations.tagActions(action.debugLabel),
                ),
              ),
            ),
          )
          .toList();
}
