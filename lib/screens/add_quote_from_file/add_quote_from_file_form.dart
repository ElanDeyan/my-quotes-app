import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/enums/form_types.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/map_extension.dart';
import 'package:my_quotes/main.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/widgets/an_error_occurred_message.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_action_button.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_author_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_content_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_is_favorite_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_select_tags_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_skeleton.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_source_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_source_uri_field.dart';
import 'package:my_quotes/shared/widgets/gap.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';

class AddQuoteFromFileForm extends StatefulWidget {
  const AddQuoteFromFileForm({
    super.key,
    required this.tagsNamesFromFile,
    required this.quoteFromFile,
  });

  final Set<String> tagsNamesFromFile;
  final Quote quoteFromFile;

  FormTypes get formType => FormTypes.addFromFile;

  @override
  State<AddQuoteFromFileForm> createState() => _AddQuoteFromFileFormState();
}

class _AddQuoteFromFileFormState extends State<AddQuoteFromFileForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  var _pickedItems = Future.value(<Tag>{});

  @override
  void initState() {
    super.initState();
    _pickedItems = _getTagsFromNames(widget.tagsNamesFromFile);
  }

  Future<Set<Tag>> _getTagsFromNames(Set<String> tagsNames) async {
    if (tagsNames.isEmpty) return const <Tag>{};

    final allTags = await databaseLocator.allTags;

    final tagsToHaveAlreadySelected = <Tag>{
      ...allTags.where((tag) => tagsNames.contains(tag.name)),
    };

    final missingTagsNames = widget.tagsNamesFromFile
        .where((tagName) => !allTags.map((tag) => tag.name).contains(tagName));

    for (final tagNameToCreate in missingTagsNames) {
      tagsToHaveAlreadySelected
          .add(await databaseLocator.createTag(tagNameToCreate));
    }

    return tagsToHaveAlreadySelected;
  }

  @override
  void dispose() {
    _formKey.currentState?.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Align(
        alignment: Alignment.topCenter,
        child: FutureBuilder(
          future: _pickedItems,
          initialData: const <Tag>{},
          builder: (context, snapshot) {
            final connectionState = snapshot.connectionState;
            final hasError = snapshot.hasError;
            final hasData = snapshot.hasData;

            final data = snapshot.data;

            return switch ((connectionState, hasError, hasData)) {
              (ConnectionState.waiting, _, _) => const QuoteFormSkeleton(),
              (ConnectionState.done, _, true) when data != null =>
                _QuoteFromFileForm(
                  formKey: _formKey,
                  quote: widget.quoteFromFile,
                  tags: data,
                ),
              _ => const AnErrorOccurredMessage(),
            };
          },
        ),
      ),
    );
  }
}

class _QuoteFromFileForm extends StatelessWidget {
  const _QuoteFromFileForm({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.tags,
    required this.quote,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;
  final Quote quote;
  final Set<Tag> tags;

  void _onSubmit(BuildContext context) {
    final isValid = _formKey.currentState?.saveAndValidate();
    if (isValid ?? false) {
      final formData = _formKey.currentState!.value.copy
        ..putIfAbsent(
          'tags',
          () {
            if (tags.isEmpty) return null;
            return tags.map((tag) => tag.id).nonNulls.join(idSeparatorChar);
          },
        );

      final quoteFromForm = Quote.fromJson(formData);

      databaseLocator.createQuote(quoteFromForm).then(
        (value) {
          if (context.mounted) {
            showToast(
              context,
              child: PillChip(
                label: Text(context.appLocalizations.quoteFormSuccessfulAdd),
              ),
            );

            context.canPop()
                ? context.pop()
                : context.goNamed(homeNavigationKey);
          }
        },
        onError: (error) => context.mounted
            ? showToast(
                context,
                child: PillChip(
                  label: Text(context.appLocalizations.quoteFormError),
                ),
              )
            : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      onChanged: _formKey.currentState?.validate,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
        ),
        child: Column(
          children: [
            QuoteFormContentField(
              initialValue: quote.content,
            ),
            const Gap.vertical(spacing: 10),
            QuoteFormAuthorField(
              initialValue: quote.author,
            ),
            const Gap.vertical(spacing: 10),
            QuoteFormSourceField(
              initialValue: quote.source,
            ),
            const Gap.vertical(spacing: 10),
            QuoteFormSourceUriField(
              initialValue: quote.sourceUri,
            ),
            const Gap.vertical(spacing: 10),
            QuoteFormIsFavoriteField(
              initialValue: quote.isFavorite,
            ),
            const Gap.vertical(spacing: 10),
            QuoteFormSelectTagsField(
              pickedItems: tags,
            ),
            const Gap.vertical(spacing: 10),
            QuoteFormActionButton(onPressed: () => _onSubmit(context)),
          ],
        ),
      ),
    );
  }
}
