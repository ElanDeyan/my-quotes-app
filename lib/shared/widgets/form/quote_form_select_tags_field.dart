import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/repository/interfaces/app_repository.dart';
import 'package:my_quotes/screens/my_quotes/_no_database_connection_message.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/shared/widgets/an_error_occurred_message.dart';
import 'package:my_quotes/shared/widgets/form/quote_form_search_tag_selection_field.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuoteFormSelectTagsField extends StatelessWidget {
  const QuoteFormSelectTagsField({
    super.key,
    required this.pickedItems,
    this.quoteForUpdate,
  });

  final Quote? quoteForUpdate;
  final Set<Tag> pickedItems;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: StreamBuilder(
        stream: serviceLocator<AppRepository>().allTagsStream,
        builder: (context, snapshot) {
          return switch ((
            snapshot.connectionState,
            snapshot.hasError,
            snapshot.hasData
          )) {
            (ConnectionState.none, _, _) => const NoDatabaseConnectionMessage(
                key: Key('no_database_connection_message'),
              ),
            (ConnectionState.waiting, _, _) =>
              const Skeletonizer(child: TextField()),
            (ConnectionState.active || ConnectionState.done, _, true) =>
              QuoteFormSearchTagSelectionField(
                pickedTags: pickedItems,
                allTags: snapshot.data!.toSet(),
              ),
            _ => const AnErrorOccurredMessage(),
          };
        },
      ),
    );
  }
}
