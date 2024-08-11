import 'package:flutter/material.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_search_tags_field.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';

class QuoteFormSearchTagSelectionField extends StatelessWidget {
  const QuoteFormSearchTagSelectionField({
    super.key,
    required this.pickedTags,
    required this.allTags,
  });

  final Set<Tag> pickedTags;
  final Set<Tag> allTags;

  @override
  Widget build(BuildContext context) {
    return MultipleSearchSelection(
      searchField: QuoteFormSearchTagsField(
        decoration: InputDecoration(
          labelText: context.appLocalizations.quoteFormFieldTags,
          hintText: context.appLocalizations.quoteFormFieldTagsHintText,
          border: const OutlineInputBorder(),
        ),
      ),
      items: allTags.toList(),
      pickedItemBuilder: (tag) => PillChip(
        label: IconWithLabel(
          icon: const Icon(
            Icons.close,
            size: 16,
          ),
          horizontalGap: 5,
          label: Text(tag.name),
        ),
      ),
      fieldToCheck: (tag) => tag.name,
      itemBuilder: (tag, index, isPicked) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Text(tag.name),
      ),
      clearSearchFieldOnSelect: true,
      noResultsWidget: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(context.appLocalizations.noResultsFound),
        ),
      ),
      showSelectAllButton: false,
      showClearAllButton: false,
      initialPickedItems: pickedTags.toList(),
      onPickedChange: (tags) => pickedTags
        ..clear()
        ..addAll(tags),
      fuzzySearch: FuzzySearch.jaro,
      showedItemsScrollPhysics: const AlwaysScrollableScrollPhysics(),
      sortPickedItems: true,
      sortShowedItems: true,
      itemsVisibility: ShowedItemsVisibility.onType,
      showedItemsBoxDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),
      ),
    );
  }
}
