import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/main.dart';
import 'package:my_quotes/screens/my_quotes/_no_database_connection_message.dart';
import 'package:my_quotes/shared/widgets/an_error_occurred_message.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_search_tags_field.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuoteFormSelectTagsField extends StatefulWidget {
  const QuoteFormSelectTagsField({
    super.key,
    required this.initialSelectedTags,
    required this.multipleSearchController,
    this.quoteForUpdate,
  });

  final Set<Tag> initialSelectedTags;
  final MultipleSearchController<Tag> multipleSearchController;
  final Quote? quoteForUpdate;

  @override
  State<QuoteFormSelectTagsField> createState() =>
      _QuoteFormSelectTagsFieldState();
}

class _QuoteFormSelectTagsFieldState extends State<QuoteFormSelectTagsField> {
  Future<List<Tag>>? _tagsForThisQuote;

  final _pickedItems = <Tag>{};

  @override
  void initState() {
    super.initState();
    _pickedItems.addAll(widget.initialSelectedTags);
    _tagsForThisQuote = widget.quoteForUpdate != null
        ? databaseLocator.getTagsByIds(widget.quoteForUpdate!.tagsId)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseLocator.allTagsStream,
      builder: (context, snapshot) {
        return switch ((
          snapshot.connectionState,
          snapshot.hasError,
          snapshot.hasData
        )) {
          (ConnectionState.none, _, _) => const NoDatabaseConnectionMessage(),
          (ConnectionState.waiting, _, _) =>
            const Skeletonizer(child: TextField()),
          (ConnectionState.active || ConnectionState.done, _, true) =>
            MultipleSearchSelection(
              searchField: QuoteFormSearchTagsField(
                decoration: InputDecoration(
                  labelText: context.appLocalizations.quoteFormFieldTags,
                  hintText: context.appLocalizations.quoteFormFieldTagsHintText,
                  border: const OutlineInputBorder(),
                ),
              ),
              items: snapshot.data!,
              controller: widget.multipleSearchController,
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
                padding: const EdgeInsets.all(8.0),
                child: Text(tag.name),
              ),
              clearSearchFieldOnSelect: true,
              noResultsWidget: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(context.appLocalizations.noResultsFound),
                ),
              ),
              showSelectAllButton: false,
              showClearAllButton: false,
              initialPickedItems: {
                ...widget.initialSelectedTags,
                ..._pickedItems,
              }.toList(),
              onPickedChange: (tags) => _pickedItems
                ..clear()
                ..addAll(tags),
              fuzzySearch: FuzzySearch.jaro,
              showedItemsScrollPhysics: const AlwaysScrollableScrollPhysics(),
              sortPickedItems: true,
              sortShowedItems: true,
              itemsVisibility: ShowedItemsVisibility.onType,
              showedItemsBoxDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          _ => const AnErrorOccurredMessage(),
        };
      },
    );
  }
}

class SelectTagsField extends StatelessWidget {
  const SelectTagsField({
    super.key,
    required this.allTags,
    required this.widget,
    required this.multipleSearchController,
  });

  final List<Tag> allTags;
  final MultipleSearchController<Tag> multipleSearchController;
  final QuoteFormSelectTagsField widget;

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
      items: allTags,
      controller: multipleSearchController,
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
        padding: const EdgeInsets.all(8.0),
        child: Text(tag.name),
      ),
      clearSearchFieldOnSelect: true,
      noResultsWidget: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.fromBorderSide(
            BorderSide(
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(context.appLocalizations.noResultsFound),
        ),
      ),
      showSelectAllButton: false,
      showClearAllButton: false,
      initialPickedItems: {
        ...widget.initialSelectedTags,
      }.toList(),
      onPickedChange: (tags) => widget.multipleSearchController, // TODO
      fuzzySearch: FuzzySearch.jaro,
      showedItemsScrollPhysics: const AlwaysScrollableScrollPhysics(),
      sortPickedItems: true,
      sortShowedItems: true,
      itemsVisibility: ShowedItemsVisibility.onType,
      showedItemsBoxDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
