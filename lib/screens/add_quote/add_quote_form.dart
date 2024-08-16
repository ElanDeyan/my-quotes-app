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

class AddQuoteForm extends StatefulWidget {
  const AddQuoteForm({super.key});

  FormTypes get formType => FormTypes.add;

  @override
  State<AddQuoteForm> createState() => _AddQuoteFormState();
}

class _AddQuoteFormState extends State<AddQuoteForm> with UpdateFormDataMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  final _pickedTags = <Tag>{};

  @override
  void dispose() {
    _formKey.currentState?.reset();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    final isValid = _formKey.currentState?.saveAndValidate() ?? false;
    if (isValid) {
      final formData =
          updateFormData(_formKey.currentState!.value.copy, _pickedTags);

      final quoteFromForm = Quote.fromJson(formData);

      databaseLocator.createQuote(quoteFromForm).then(
        (createdQuote) {
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
            log('Error', name: 'AddQuoteFormError', error: error);
          }
        },
      );
    } else {
      showToast(
        context,
        child: PillChip(label: Text(context.appLocalizations.quoteFormError)),
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.8,
              ),
              child: Column(
                children: [
                  const QuoteFormContentField(),
                  const Gap.vertical(spacing: 10),
                  const QuoteFormAuthorField(),
                  const Gap.vertical(spacing: 10),
                  const QuoteFormSourceField(),
                  const Gap.vertical(spacing: 10),
                  const QuoteFormSourceUriField(),
                  const Gap.vertical(spacing: 10),
                  const QuoteFormIsFavoriteField(),
                  const Gap.vertical(spacing: 10),
                  QuoteFormSelectTagsField(
                    pickedItems: _pickedTags,
                  ),
                  const Gap.vertical(spacing: 10),
                  QuoteFormActionButton(
                    onPressed: () => _onSubmit(context),
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
