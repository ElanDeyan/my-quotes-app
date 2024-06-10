import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/tag_actions.dart';

class SearchTagResults extends StatelessWidget {
  const SearchTagResults({super.key, required this.searchResults});

  final List<Tag> searchResults;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(searchResults[index].name),
          trailing: PopupMenuButton(
            tooltip: 'Actions',
            itemBuilder: (context) =>
                TagActions.popupMenuItems(context, searchResults[index]),
          ),
        ),
      ),
    );
  }
}
