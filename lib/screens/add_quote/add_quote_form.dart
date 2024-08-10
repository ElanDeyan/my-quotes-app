import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:my_quotes/constants/enums/form_types.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_action_button.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_author_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_content_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_is_favorite_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_select_tags_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_source_field.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_source_uri_field.dart';
import 'package:my_quotes/shared/widgets/gap.dart';

class AddQuoteForm extends StatefulWidget {
  const AddQuoteForm({super.key});

  FormTypes get formType => FormTypes.add;

  @override
  State<AddQuoteForm> createState() => _AddQuoteFormState();
}

class _AddQuoteFormState extends State<AddQuoteForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final MultipleSearchController<Tag> _multipleTagSelectionController;
  final _pickedItems = <Tag>{};

  @override
  void initState() {
    super.initState();
    _multipleTagSelectionController = MultipleSearchController<Tag>(
      allowDuplicateSelection: false,
    );
  }

  @override
  void dispose() {
    _multipleTagSelectionController
      ..clearAllPickedItems()
      ..clearSearchField();
    _formKey.currentState?.reset();
    super.dispose();
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
                    initialSelectedTags: _pickedItems,
                    multipleSearchController: _multipleTagSelectionController,
                  ),
                  const Gap.vertical(spacing: 10),
                  const QuoteFormActionButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
