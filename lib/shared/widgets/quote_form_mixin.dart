import 'dart:async';

import 'package:basics/basics.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:my_quotes/constants/enums/form_types.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/nullable_extension.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_author_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_content_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_is_favorite_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_search_tags_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_source_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_source_uri_field.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

mixin QuoteFormMixin {
  final formKey = GlobalKey<FormBuilderState>();

  FormTypes get formType => FormTypes.add;

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
            const QuoteFormContentField(),
            const SizedBox(
              height: 10,
            ),
            _authorTextField(context),
            const SizedBox(
              height: 10,
            ),
            const QuoteFormSourceField(),
            const SizedBox(
              height: 10,
            ),
            const QuoteFormSourceUriField(),
            const SizedBox(
              height: 10,
            ),
            const QuoteFormIsFavoriteField(),
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

  Widget _authorTextField(BuildContext context) {
    final fieldName = context.appLocalizations.quoteFormFieldAuthor;
    return formType != FormTypes.add
        ? const QuoteFormAuthorField()
        : FormBuilderTextField(
            name: 'author',
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: fieldName,
            ),
            initialValue: context.appLocalizations.quoteFormFieldAnonymAuthor,
            smartQuotesType: SmartQuotesType.enabled,
            smartDashesType: SmartDashesType.enabled,
            keyboardType: TextInputType.name,
            validator: FormBuilderValidators.required(
              errorText: context.appLocalizations.nonEmptyField(fieldName),
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
                searchField: QuoteFormSearchTagsField(
                  decoration: InputDecoration(
                    labelText: context.appLocalizations.quoteFormFieldTags,
                    hintText:
                        context.appLocalizations.quoteFormFieldTagsHintText,
                    border: const OutlineInputBorder(),
                  ),
                ),
                controller: controller,
                items: allTags,
                fieldToCheck: (tag) => tag.name,
                clearSearchFieldOnSelect: true,
                noResultsWidget: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(context.appLocalizations.noResultsFound),
                ),
                showSelectAllButton: false,
                showClearAllButton: false,
                initialPickedItems: <Tag>{
                  ...?snapshot.data!.last,
                  ..._pickedItems,
                }.toList(),
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
                itemBuilder: (tag, index, isPicked) => Padding(
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
    final actionButtonText = formType == FormTypes.update
        ? context.appLocalizations.quoteFormActionButtonEdit
        : context.appLocalizations.quoteFormActionButtonAdd;

    final actionButtonIcon = formType == FormTypes.update
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
              () {
                final value = multipleTagSearchController
                    .getPickedItems()
                    .map((tag) => tag.id)
                    .nonNulls
                    .join(idSeparatorChar);

                return value.isNullOrBlank ? '' : value;
              },
            );

            final Quote quoteFromForm;

            if (formType == FormTypes.update) {
              quoteFromForm = Quote.fromJson(formValue).copyWith(
                id: Value.absentIfNull(quoteForUpdate!.id),
                createdAt: Value.absentIfNull(quoteForUpdate.createdAt),
              );
            } else {
              quoteFromForm = Quote.fromJson(formValue);
            }

            scheduleMicrotask(
              () {
                final result = formType == FormTypes.update
                    ? database.updateQuote(quoteFromForm)
                    : database.createQuote(quoteFromForm);

                result.then((value) {
                  if (value case true || int _) {
                    if (context.mounted) {
                      final successfulMessage = formType == FormTypes.update
                          ? context.appLocalizations.quoteFormSuccessfulEdit
                          : context.appLocalizations.quoteFormSuccessfulAdd;
                      showToast(
                        context,
                        child: PillChip(label: Text(successfulMessage)),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      showToast(
                        context,
                        child: PillChip(
                          label: Text(
                            context.appLocalizations.quoteFormError,
                          ),
                        ),
                      );
                    }
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
