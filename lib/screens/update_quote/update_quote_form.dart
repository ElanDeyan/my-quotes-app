import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/enums/form_types.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/map_extension.dart';
import 'package:my_quotes/helpers/quote_extension.dart';
import 'package:my_quotes/repository/interfaces/app_repository.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/my_quotes/_no_database_connection_message.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/widgets/an_error_occurred_message.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_action_button.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_author_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_content_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_is_favorite_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_select_tags_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_source_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_source_uri_field.dart';
import 'package:my_quotes/shared/widgets/form/update_form_data_mixin.dart';
import 'package:my_quotes/shared/widgets/gap.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';
import 'package:my_quotes/states/service_locator.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UpdateQuoteForm extends StatefulWidget {
  const UpdateQuoteForm({
    super.key,
    required this.quote,
  });

  final Quote quote;
  FormTypes get formType => FormTypes.update;

  @override
  State<UpdateQuoteForm> createState() => _UpdateQuoteFormState();
}

class _UpdateQuoteFormState extends State<UpdateQuoteForm>
    with UpdateFormDataMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  final _pickedTags = <Tag>{};

  @override
  void dispose() {
    _formKey.currentState?.reset();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    final isValid = _formKey.currentState?.saveAndValidate();

    if (isValid ?? false) {
      final formData =
          updateFormData(_formKey.currentState!.value.copy, _pickedTags);

      final quoteFromForm = Quote.fromJson(formData).copyWith(
        id: Value(widget.quote.id),
        createdAt: Value(widget.quote.createdAt),
      );

      serviceLocator<AppRepository>().updateQuote(quoteFromForm).then(
        (value) {
          if (context.mounted) {
            showToast(
              context,
              child: PillChip(
                label: Text(context.appLocalizations.quoteFormSuccessfulEdit),
              ),
            );

            context.canPop()
                ? context.pop()
                : context.goNamed(homeNavigationKey);
          }
        },
        onError: (Object? error) {
          if (context.mounted) {
            showToast(
              context,
              child: PillChip(
                label: Text(context.appLocalizations.quoteFormError),
              ),
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: FormBuilder(
            key: _formKey,
            onChanged: _formKey.currentState?.validate,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Column(
                children: [
                  QuoteFormContentField(
                    key: const Key('quote_form_content_field'),
                    initialValue: widget.quote.content,
                  ),
                  const Gap.vertical(spacing: 10),
                  QuoteFormAuthorField(
                    key: const Key('quote_form_author_field'),
                    formType: widget.formType,
                    initialValue: widget.quote.author,
                  ),
                  const Gap.vertical(spacing: 10),
                  QuoteFormSourceField(
                    key: const Key('quote_form_source_field'),
                    initialValue: widget.quote.source,
                  ),
                  const Gap.vertical(spacing: 10),
                  QuoteFormSourceUriField(
                    key: const Key('quote_form_source_uri_field'),
                    initialValue: widget.quote.sourceUri,
                  ),
                  const Gap.vertical(spacing: 10),
                  QuoteFormIsFavoriteField(
                    key: const Key('quote_form_is_favorite_field'),
                    initialValue: widget.quote.isFavorite,
                  ),
                  const Gap.vertical(spacing: 10),
                  _FutureSelectedTagsField(
                    quote: widget.quote,
                    tagSetToUpdate: _pickedTags,
                  ),
                  const Gap.vertical(spacing: 10),
                  QuoteFormActionButton(
                    key: const Key(
                      'quote_form_update_quote_action_button_field',
                    ),
                    onPressed: () => _onSubmit(context),
                    formType: widget.formType,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FutureSelectedTagsField extends StatelessWidget {
  const _FutureSelectedTagsField({
    super.key,
    required this.quote,
    required this.tagSetToUpdate,
  });

  final Quote quote;
  final Set<Tag> tagSetToUpdate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: serviceLocator<AppRepository>().getTagsByIds(quote.tagsId),
      builder: (context, snapshot) {
        final connectionState = snapshot.connectionState;
        final hasError = snapshot.hasError;
        final hasData = snapshot.hasData;

        final data = snapshot.data;

        if (connectionState == ConnectionState.done && data != null) {
          tagSetToUpdate.addAll(data);
        }

        return switch ((connectionState, hasError, hasData)) {
          (ConnectionState.done, _, true) when data != null =>
            QuoteFormSelectTagsField(
              key: const Key('quote_form_select_tags_field'),
              pickedItems: tagSetToUpdate,
            ),
          (ConnectionState.waiting, _, _) =>
            const Skeletonizer(child: TextField()),
          (ConnectionState.none, _, _) => const NoDatabaseConnectionMessage(
              key: Key('no_database_connection_message'),
            ),
          _ => const AnErrorOccurredMessage(),
        };
      },
    );
  }
}
