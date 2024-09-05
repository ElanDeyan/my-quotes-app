import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_quotes/constants/enums/form_types.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/repository/interfaces/app_repository.dart';
import 'package:my_quotes/screens/add_quote_from_file/add_quote_from_file_form.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/shared/widgets/an_error_occurred_message.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_skeleton.dart';

class AddQuoteFromFileProvider extends StatefulWidget {
  const AddQuoteFromFileProvider({
    super.key,
    required this.tagsNamesFromFile,
    required this.quoteFromFile,
  });

  final Set<String> tagsNamesFromFile;
  final Quote quoteFromFile;

  FormTypes get formType => FormTypes.addFromFile;

  @override
  State<AddQuoteFromFileProvider> createState() =>
      _AddQuoteFromFileProviderState();
}

class _AddQuoteFromFileProviderState extends State<AddQuoteFromFileProvider> {
  final _formKey = GlobalKey<FormBuilderState>();
  var _pickedItems = Future.value(<Tag>{});

  @override
  void initState() {
    super.initState();
    _pickedItems = _getTagsFromNames(widget.tagsNamesFromFile);
  }

  Future<Set<Tag>> _getTagsFromNames(Set<String> tagsNames) async {
    if (tagsNames.isEmpty) return const <Tag>{};

    final appRepository = serviceLocator<AppRepository>();

    final allTags = await appRepository.allTags;

    final tagsToHaveAlreadySelected = <Tag>{
      ...allTags.where((tag) => tagsNames.contains(tag.name)),
    };

    final missingTagsNames = widget.tagsNamesFromFile
        .where((tagName) => !allTags.map((tag) => tag.name).contains(tagName));

    for (final tagNameToCreate in missingTagsNames) {
      tagsToHaveAlreadySelected.add(
        await appRepository.createTag(tagNameToCreate),
      );
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                (ConnectionState.done, _, true) when data != null =>
                  AddQuoteFromFileForm(
                    key: const Key('add_quote_from_file_form'),
                    formKey: _formKey,
                    quote: widget.quoteFromFile,
                    tags: data,
                    formType: widget.formType,
                  ),
                (ConnectionState.waiting, _, _) =>
                  const QuoteFormSkeleton(key: Key('quote_form_skeleton')),
                _ => const AnErrorOccurredMessage(),
              };
            },
          ),
        ),
      ),
    );
  }
}
