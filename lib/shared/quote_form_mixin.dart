import 'dart:async';

import 'package:basics/basics.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/iterable_extension.dart';
import 'package:my_quotes/helpers/nullable_extension.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

mixin QuoteFormMixin {
  final formKey = GlobalKey<FormBuilderState>();

  bool get isUpdateForm => false;

  final _multipleTagSearchController = MultipleSearchController<Tag>();

  final urlPattern = RegExp(
    r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)',
  );

  String? sourceUriValidator(String? value) {
    if (value.isNotNullOrBlank) {
      if (!urlPattern.hasMatch(value!)) {
        return 'Enter a valid link';
      }
    }
    return null;
  }

  final _pickedItems = <Tag>[];

  Widget quoteFormBody(BuildContext context, {Quote? quoteForUpdate}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.8),
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'content',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Content',
              ),
              maxLines: null,
              smartQuotesType: SmartQuotesType.enabled,
              keyboardType: TextInputType.multiline,
              enableSuggestions: true,
              smartDashesType: SmartDashesType.enabled,
              validator: (value) {
                if (value.isNullOrBlank) {
                  return "Can't be empty.";
                }
                return null;
              },
              valueTransformer: (value) => value?.trim(),
            ),
            const SizedBox(
              height: 10,
            ),
            _authorTextField(),
            const SizedBox(
              height: 10,
            ),
            FormBuilderTextField(
              name: 'source',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Source',
                hintText: 'Like a movie, book, event, place and etc',
              ),
              keyboardType: TextInputType.text,
              enableSuggestions: true,
              smartQuotesType: SmartQuotesType.enabled,
              smartDashesType: SmartDashesType.enabled,
              valueTransformer: (value) => value?.trim(),
            ),
            const SizedBox(
              height: 10,
            ),
            FormBuilderTextField(
              name: 'sourceUri',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Source link',
                hintText: 'Link to the source',
              ),
              validator: sourceUriValidator,
              enableSuggestions: true,
              smartDashesType: SmartDashesType.enabled,
              smartQuotesType: SmartQuotesType.enabled,
              keyboardType: TextInputType.url,
              valueTransformer: (value) => value?.trim(),
            ),
            const SizedBox(
              height: 10,
            ),
            FormBuilderCheckbox(
              name: 'isFavorite',
              title: const Text('Is favorite?'),
              shape: StarBorder(
                squash: .5,
                innerRadiusRatio: .5,
                side:
                    BorderSide(color: Theme.of(context).colorScheme.onSurface),
              ),
              checkColor: Colors.transparent,
              valueTransformer: (value) => value ?? false,
            ),
            const SizedBox(
              height: 10,
            ),
            _selectTags(
              context,
              _multipleTagSearchController,
              quoteForUpdate: quoteForUpdate,
            ),
            const SizedBox(
              height: 10,
            ),
            _actionButton(quoteForUpdate),
          ],
        ),
      ),
    );
  }

  FormBuilderTextField _authorTextField() {
    return isUpdateForm
        ? FormBuilderTextField(
            name: 'author',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Author',
            ),
            smartQuotesType: SmartQuotesType.enabled,
            keyboardType: TextInputType.name,
            enableSuggestions: true,
            smartDashesType: SmartDashesType.enabled,
            validator: (value) {
              if (value.isNullOrBlank) {
                return "Can't be empty.";
              }
              return null;
            },
            valueTransformer: (value) => value?.trim(),
          )
        : FormBuilderTextField(
            name: 'author',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Author',
            ),
            initialValue: 'Anonym',
            smartQuotesType: SmartQuotesType.enabled,
            enableSuggestions: true,
            smartDashesType: SmartDashesType.enabled,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value.isNullOrBlank) {
                return "Can't be empty.";
              }
              return null;
            },
            valueTransformer: (value) => value?.trim(),
          );
  }

  Consumer<DatabaseProvider> _selectTags(
    BuildContext context,
    MultipleSearchController<Tag> controller, {
    Quote? quoteForUpdate,
  }) {
    Future<List<Tag>>? tagsForThisQuote;
    if (quoteForUpdate.isNotNull) {
      tagsForThisQuote = Provider.of<DatabaseProvider>(context, listen: false)
          .getTagsByIds(quoteForUpdate!.tagsId);
    }

    return Consumer<DatabaseProvider>(
      builder: (context, database, child) => FutureBuilder(
        future: Future.wait<List<Tag>?>(
          [database.allTags, Future.value(tagsForThisQuote)],
        ),
        initialData: const [<Tag>[], null],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              final allTags = snapshot.data!.first!;
              return MultipleSearchSelection(
                searchField: const TextField(
                  decoration: InputDecoration(
                    labelText: 'Tags',
                    hintText: 'Tag name',
                    border: OutlineInputBorder(),
                  ),
                  smartDashesType: SmartDashesType.enabled,
                  smartQuotesType: SmartQuotesType.enabled,
                  keyboardType: TextInputType.name,
                ),
                controller: controller,
                items: allTags,
                fieldToCheck: (tag) => tag.name,
                clearSearchFieldOnSelect: true,
                showSelectAllButton: false,
                showClearAllButton: false,
                initialPickedItems: <Tag>[
                  ...?snapshot.data!.last,
                  ..._pickedItems,
                ].uniques.toList(),
                onPickedChange: (tags) => _pickedItems
                  ..clear()
                  ..addAll(tags),
                pickedItemBuilder: (tag) => Chip(
                  labelPadding: const EdgeInsets.all(1),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tag.name),
                      const SizedBox(
                        width: 2.5,
                      ),
                      const Icon(
                        Icons.close,
                        size: 14,
                      ),
                    ],
                  ),
                ),
                fuzzySearch: FuzzySearch.jaro,
                showedItemsScrollPhysics: const AlwaysScrollableScrollPhysics(),
                sortShowedItems: true,
                sortPickedItems: true,
                showedItemsBoxDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                ),
                itemsVisibility: ShowedItemsVisibility.onType,
                itemBuilder: (tag, _) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(tag.name),
                ),
              );
            } else {
              return const Text('Error');
            }
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Consumer<DatabaseProvider> _actionButton(Quote? quoteForUpdate) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) => OutlinedButton.icon(
        icon: isUpdateForm ? const Icon(Icons.edit_outlined) : const Icon(Icons.add_outlined),
        label: isUpdateForm ? const Text('Update') : const Text('Create'),
        onPressed: () {
          final isValid = formKey.currentState?.saveAndValidate() ?? false;
          if (isValid) {
            final formValue = formKey.currentState!.value.map(
              (key, value) => MapEntry(key, value),
            );

            formValue.putIfAbsent(
              'tags',
              () => _multipleTagSearchController
                  .getPickedItems()
                  .map((tag) => tag.id)
                  .nonNulls
                  .join(idSeparatorChar),
            );

            final Quote quoteFromForm;

            if (isUpdateForm) {
              quoteFromForm = Quote.fromJson(formValue).copyWith(
                id: Value(quoteForUpdate!.id),
                createdAt: Value(quoteForUpdate.createdAt),
              );
            } else {
              quoteFromForm = Quote.fromJson(formValue);
            }

            scheduleMicrotask(
              () {
                final result = isUpdateForm
                    ? database.updateQuote(quoteFromForm)
                    : database.addQuote(quoteFromForm);

                result.then((value) {
                  if (value case true || int _) {
                    FToast().init(context).showToast(
                          child: Chip(
                            label: Text(
                              'Successfully ${isUpdateForm ? 'updated' : 'added'}!',
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        );
                  } else {
                    FToast().init(context).showToast(
                          child: Chip(
                            label: const Text('Error'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        );
                  }
                });
              },
            );
            formKey.currentState?.reset();
            _multipleTagSearchController..clearAllPickedItems()..clearSearchField();
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
