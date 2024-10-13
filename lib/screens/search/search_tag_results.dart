import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/shared/actions/tags/tag_actions.dart';

class SearchTagResults extends StatelessWidget {
  const SearchTagResults({required this.searchResults, super.key});

  final List<Tag> searchResults;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(searchResults[index].name),
          trailing: PopupMenuButton(
            tooltip: context.appLocalizations.tagActionsPopupButtonTooltip,
            itemBuilder: (context) =>
                TagActions.popupMenuItems(context, searchResults[index]),
          ),
        ),
      ),
    );
  }
}
