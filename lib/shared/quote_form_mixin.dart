import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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

  final multipleTagSearchController = MultipleSearchController<Tag>();

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
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.quoteFormFieldContent,
              ),
              maxLines: null,
              smartQuotesType: SmartQuotesType.enabled,
              keyboardType: TextInputType.multiline,
              enableSuggestions: true,
              smartDashesType: SmartDashesType.enabled,
              validator: FormBuilderValidators.required(
                errorText: AppLocalizations.of(context)!.nonEmptyField(
                  AppLocalizations.of(context)!.quoteFormFieldContent,
                ),
              ),
              valueTransformer: (value) => value?.trim(),
            ),
            const SizedBox(
              height: 10,
            ),
            _authorTextField(context),
            const SizedBox(
              height: 10,
            ),
            FormBuilderTextField(
              name: 'source',
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.quoteFormFieldSource,
                hintText:
                    AppLocalizations.of(context)!.quoteFormFieldSourceHintText,
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
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText:
                    AppLocalizations.of(context)!.quoteFormFieldSourceUri,
                hintText: AppLocalizations.of(context)!
                    .quoteFormFieldSourceUriHintText,
              ),
              validator: FormBuilderValidators.url(),
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
              title:
                  Text(AppLocalizations.of(context)!.quoteFormFieldIsFavorite),
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
              multipleTagSearchController,
              quoteForUpdate: quoteForUpdate,
            ),
            const SizedBox(
              height: 10,
            ),
            _actionButton(context, quoteForUpdate),
          ],
        ),
      ),
    );
  }

  FormBuilderTextField _authorTextField(BuildContext context) {
    final fieldName = AppLocalizations.of(context)!.quoteFormFieldAuthor;
    return isUpdateForm
        ? FormBuilderTextField(
            name: 'author',
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: fieldName,
            ),
            smartQuotesType: SmartQuotesType.enabled,
            keyboardType: TextInputType.name,
            enableSuggestions: true,
            smartDashesType: SmartDashesType.enabled,
            validator: FormBuilderValidators.required(
              errorText: AppLocalizations.of(context)!.nonEmptyField(
                fieldName,
              ),
            ),
            valueTransformer: (value) => value?.trim(),
          )
        : FormBuilderTextField(
            name: 'author',
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: fieldName,
            ),
            initialValue:
                AppLocalizations.of(context)!.quoteFormFieldAnonymAuthor,
            smartQuotesType: SmartQuotesType.enabled,
            enableSuggestions: true,
            smartDashesType: SmartDashesType.enabled,
            keyboardType: TextInputType.name,
            validator: FormBuilderValidators.required(
              errorText: AppLocalizations.of(context)!.nonEmptyField(fieldName),
            ),
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
                searchField: TextField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.quoteFormFieldTags,
                    hintText: AppLocalizations.of(context)!
                        .quoteFormFieldTagsHintText,
                    border: const OutlineInputBorder(),
                  ),
                  smartDashesType: SmartDashesType.enabled,
                  smartQuotesType: SmartQuotesType.enabled,
                  keyboardType: TextInputType.name,
                ),
                controller: controller,
                items: allTags,
                fieldToCheck: (tag) => tag.name,
                clearSearchFieldOnSelect: true,
                noResultsWidget: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(AppLocalizations.of(context)!.noResultsFound),
                ),
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
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
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

  Consumer<DatabaseProvider> _actionButton(
    BuildContext context,
    Quote? quoteForUpdate,
  ) {
    final actionButtonText = isUpdateForm
        ? AppLocalizations.of(context)!.quoteFormActionButtonEdit
        : AppLocalizations.of(context)!.quoteFormActionButtonAdd;

    final actionButtonIcon = isUpdateForm
        ? const Icon(Icons.save_outlined)
        : const Icon(Icons.create_outlined);
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) => OutlinedButton.icon(
        icon: actionButtonIcon,
        label: Text(actionButtonText),
        onPressed: () {
          final isValid = formKey.currentState?.saveAndValidate() ?? false;
          if (isValid) {
            final formValue = formKey.currentState!.value.map(
              (key, value) => MapEntry(key, value),
            );

            formValue.putIfAbsent(
              'tags',
              () => multipleTagSearchController
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
                    final successfulMessage = isUpdateForm
                        ? AppLocalizations.of(context)!.quoteFormSuccessfulEdit
                        : AppLocalizations.of(context)!.quoteFormSuccessfulAdd;
                    FToast().init(context).showToast(
                          child: Chip(
                            label: Text(
                              successfulMessage,
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
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
