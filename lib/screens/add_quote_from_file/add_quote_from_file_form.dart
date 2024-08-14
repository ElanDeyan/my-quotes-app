import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/constants/enums/form_types.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/map_extension.dart';
import 'package:my_quotes/main.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
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

class AddQuoteFromFileForm extends StatelessWidget with UpdateFormDataMixin {
  const AddQuoteFromFileForm({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.tags,
    required this.quote,
    required this.formType,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;
  final Quote quote;
  final Set<Tag> tags;
  final FormTypes formType;

  void _onSubmit(BuildContext context) {
    final isValid = _formKey.currentState?.saveAndValidate();
    if (isValid ?? false) {
      final formData = updateFormData(_formKey.currentState!.value.copy, tags);

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
        onError: (Object? error) {
          if (context.mounted) {
            showToast(
              context,
              child: PillChip(
                label: Text(context.appLocalizations.quoteFormError),
              ),
            );
            log('Error', name: 'AddQuoteFormFromFileError', error: error);
          }
        },
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
              formType: formType,
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
            QuoteFormActionButton(
              onPressed: () => _onSubmit(context),
              formType: formType,
            ),
          ],
        ),
      ),
    );
  }
}
