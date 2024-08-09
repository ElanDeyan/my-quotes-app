import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_quotes/constants/enums/form_types.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/widgets/quote_form_mixin.dart';

class AddQuoteFromFileFormBuilder extends StatefulWidget {
  const AddQuoteFromFileFormBuilder({
    super.key,
    required this.tagsIds,
    required this.quoteAsJson,
  });

  final List<String> tagsIds;
  final Map<String, Object?> quoteAsJson;

  @override
  State<AddQuoteFromFileFormBuilder> createState() =>
      _AddQuoteFromFileFormBuilderState();
}

class _AddQuoteFromFileFormBuilderState
    extends State<AddQuoteFromFileFormBuilder> with QuoteFormMixin {
  @override
  void dispose() {
    multipleTagSearchController
      ..clearAllPickedItems()
      ..clearSearchField();
    formKey.currentState?.reset();
    super.dispose();
  }

  @override
  FormTypes get formType => FormTypes.addFromFile;

  @override
  Widget build(BuildContext context) {
    final tagsIdsAsString = widget.tagsIds.join(idSeparatorChar);
    final updatedQuoteJson = widget.quoteAsJson.map(
      (key, value) =>
          key == 'tags' ? MapEntry(key, widget.tagsIds) : MapEntry(key, value),
    );
    final updatedQuote = Quote.fromJson(
      updatedQuoteJson.map(
        (key, value) => key == 'tags'
            ? MapEntry(key, tagsIdsAsString)
            : MapEntry(key, value),
      ),
    );

    return FormBuilder(
      key: formKey,
      onChanged: formKey.currentState?.validate,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: widget.quoteAsJson,
      child: quoteFormBody(
        context,
        quoteForUpdate: updatedQuote,
      ),
    );
  }
}
