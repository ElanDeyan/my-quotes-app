import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/delete_tag.dart';
import 'package:my_quotes/shared/icon_with_label.dart';
import 'package:my_quotes/shared/update_tag.dart';

enum TagActions {
  update(
    label: Text('Update'),
    name: 'Update',
    icon: Icon(Icons.edit_outlined),
  ),
  delete(
    label: Text('Delete'),
    name: 'Delete',
    icon: Icon(Icons.delete_outline),
  );

  const TagActions({
    required this.label,
    required this.name,
    required this.icon,
  });

  final Widget label;
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
                TagActions.update => () => updateTag(context, tag),
                TagActions.delete => () => deleteTag(context, tag),
              },
              child: IconWithLabel(
                icon: action.icon,
                horizontalGap: 10,
                label: action.label,
              ),
            ),
          )
          .toList();
}
