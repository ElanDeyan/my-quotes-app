import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/actions/tags/tag_actions.dart';

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
            tooltip: AppLocalizations.of(context)!.tagActionsPopupButtonTooltip,
            itemBuilder: (context) =>
                TagActions.popupMenuItems(context, searchResults[index]),
          ),
        ),
      ),
    );
  }
}
