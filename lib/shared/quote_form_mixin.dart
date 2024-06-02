import 'dart:async';

import 'package:basics/basics.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:multiple_search_selection/createable/create_options.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
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

  Column quoteFormBody(BuildContext context, {Quote? quoteForUpdate}) {
    return Column(
      children: [
        FormBuilderTextField(
          name: 'content',
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Content',
          ),
          maxLines: null,
          smartQuotesType: SmartQuotesType.enabled,
          validator: (value) {
            if (value.isNullOrBlank) {
              return "Can't be empty.";
            }
            return null;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        authorTextField(),
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
        ),
        const SizedBox(
          height: 10,
        ),
        if (isUpdateForm)
          FormBuilderCheckbox(
            name: 'isFavorite',
            title: const Text('Is favorite?'),
          )
        else
          FormBuilderCheckbox(
            name: 'isFavorite',
            initialValue: false,
            title: const Text('Is favorite?'),
          ),
        const SizedBox(
          height: 10,
        ),
        selectTags(context, _multipleTagSearchController),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: tagsChipFilter()),
            createTagButton(),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        if (isUpdateForm)
          updateQuoteButton(quoteForUpdate!)
        else
          createQuoteButton(),
      ],
    );
  }

  FormBuilderTextField authorTextField() {
    return isUpdateForm
        ? FormBuilderTextField(
            name: 'author',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Author',
            ),
            smartQuotesType: SmartQuotesType.enabled,
            validator: (value) {
              if (value.isNullOrBlank) {
                return "Can't be empty.";
              }
              return null;
            },
          )
        : FormBuilderTextField(
            name: 'author',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Author',
            ),
            initialValue: 'Anonym',
            smartQuotesType: SmartQuotesType.enabled,
            validator: (value) {
              if (value.isNullOrBlank) {
                return "Can't be empty.";
              }
              return null;
            },
          );
  }

  FutureBuilder<List<Tag>> selectTags(
    BuildContext context,
    MultipleSearchController<Tag> controller,
  ) {
    final database = Provider.of<DatabaseProvider>(context, listen: false);
    return FutureBuilder(
      future: database.allTags,
      initialData: const <Tag>[],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasError) {
            final tags = snapshot.data!;
            return FormBuilderField<MultipleSearchSelection<Tag>>(
              builder: (builder) => MultipleSearchSelection.creatable(
                searchField: const TextField(
                  decoration: InputDecoration(
                    labelText: 'Tags',
                    hintText: 'Tag name',
                    border: OutlineInputBorder(),
                  ),
                ),
                items: tags,
                fieldToCheck: (tag) => tag.name,
                // initialPickedItems:
                //     isUpdateForm ? controller.getPickedItems() : <Tag>[],
                pickedItemBuilder: (tag) => Chip(
                  label: Text(tag.name),
                  deleteIcon: const Icon(Icons.close),
                ),
                controller: controller,
                itemsVisibility: ShowedItemsVisibility.onType,
                itemBuilder: (tag, i) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(tag.name),
                ),
                createOptions: CreateOptions(
                  create: (text) => Tag(name: text),
                  onCreated: (tag) async => await database.createTag(tag),
                  pickCreated: true,
                  createBuilder: (text) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Create tag: $text'),
                  ),
                ),
              ),
              name: 'newTags',
              valueTransformer: (field) => controller.getPickedItems(),
            );
          } else {
            return const Text('Error');
          }
        }

        return const CircularProgressIndicator();
      },
    );
  }

  Consumer<DatabaseProvider> tagsChipFilter() {
    return Consumer<DatabaseProvider>(
      builder: (context, value, child) {
        return FutureBuilder(
          future: value.allTags,
          initialData: const <Tag>[],
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return FormBuilderFilterChip(
                  name: 'tags',
                  spacing: 10,
                  options: [
                    for (final tag in snapshot.data!)
                      FormBuilderChipOption(
                        value: tag.id!.toString(),
                        child: Text(tag.name),
                      ),
                  ],
                );
              } else {
                return const Text('No data');
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );
  }

  Consumer<DatabaseProvider> createTagButton() => Consumer<DatabaseProvider>(
        builder: (context, database, child) => ElevatedButton(
          onPressed: () async {
            final tagToAdd = await showDialog<String?>(
              context: context,
              builder: (context) {
                final textEditingController = TextEditingController();
                final createTagFormKey = GlobalKey<FormState>();
                return AlertDialog(
                  title: const Text('Create tag'),
                  content: Form(
                    key: createTagFormKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tag name',
                      ),
                      controller: textEditingController,
                      validator: (value) {
                        if (value.isNullOrBlank) {
                          return "Can't be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(
                        context,
                        textEditingController.text,
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                );
              },
            );

            if (tagToAdd.isNotNullOrBlank) {
              database.createTag(Tag(name: tagToAdd!));
            }
          },
          child: const Text('Create tag'),
        ),
      );

  Consumer<DatabaseProvider> createQuoteButton() {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) => ElevatedButton(
        child: const Text('Save'),
        onPressed: () {
          formKey.currentState!.saveAndValidate();

          var actualFormValue = formKey.currentState!.value;

          List<String>? newTagsValue(List<String>? tagsField) {
            final tagsValue = tagsField ?? const <String>[];
            if (tagsValue.isEmpty) {
              return null;
            } else {
              final tagsValueAsIntList = tagsValue
                  .map((tagsValue) => int.tryParse(tagsValue))
                  .nonNulls;

              return tagsValueAsIntList.isEmpty
                  ? null
                  : tagsValueAsIntList
                      .map((value) => value.toString())
                      .toList();
            }
          }

          formKey.currentState!.patchValue({
            'tags': newTagsValue(
              actualFormValue['tags'] as List<String>?,
            ),
          });

          actualFormValue = formKey.currentState!.value;

          final newFormValue = actualFormValue.map(
            (key, value) => MapEntry(key, value),
          )..update(
              'tags',
              (value) => switch (value) {
                final List<String> a when a.isNotEmpty => a.join(','),
                _ => null,
              },
              ifAbsent: () => null,
            );

          print(newFormValue);

          final quoteFromForm = Quote.fromJson(newFormValue);
          scheduleMicrotask(
            () {
              database.addQuote(quoteFromForm).then(
                    (value) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Success fully added!'),
                      ),
                    ),
                    onError: (error) =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('An error occurred.'),
                      ),
                    ),
                  );
            },
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  Consumer<DatabaseProvider> updateQuoteButton(Quote quote) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) => ElevatedButton(
        child: const Text('Save'),
        onPressed: () {
          formKey.currentState!.saveAndValidate();

          var actualFormValue = formKey.currentState!.value;

          List<String>? newTagsValue(List<String>? tagsField) {
            final tagsValue = tagsField ?? const <String>[];
            if (tagsValue.isEmpty) {
              return null;
            } else {
              final tagsValueAsIntList = tagsValue
                  .map((tagsValue) => int.tryParse(tagsValue))
                  .nonNulls;

              return tagsValueAsIntList.isEmpty
                  ? null
                  : tagsValueAsIntList
                      .map((value) => value.toString())
                      .toList();
            }
          }

          formKey.currentState!.patchValue({
            'tags': newTagsValue(
              actualFormValue['tags'] as List<String>?,
            ),
          });

          actualFormValue = formKey.currentState!.value;

          final newFormValue = actualFormValue.map(
            (key, value) => MapEntry(key, value),
          )..update(
              'tags',
              (value) => switch (value) {
                final List<String> a when a.isNotEmpty => a.join(','),
                _ => null,
              },
              ifAbsent: () => null,
            );

          final quoteFromForm = Quote.fromJson(newFormValue).copyWith(
            id: Value(quote.id),
            createdAt: Value(quote.createdAt),
          );
          scheduleMicrotask(
            () {
              database.updateQuote(quoteFromForm).then(
                    (value) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Successfully updated!'),
                      ),
                    ),
                    onError: (error) =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('An error occurred.'),
                      ),
                    ),
                  );
            },
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}
