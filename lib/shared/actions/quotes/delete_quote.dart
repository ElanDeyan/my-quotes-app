import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/repository/interfaces/app_repository.dart';
import 'package:my_quotes/shared/actions/quotes/show_delete_quote_dialog.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';
import 'package:my_quotes/states/service_locator.dart';

Future<void> deleteQuote(BuildContext context, Quote quote) async {
  final result = showDeleteQuoteDialog(context, quote);

  result.then((value) {
    if (value == true) {
      serviceLocator<AppRepository>().deleteQuote(quote.id!).then(
            (_) => context.mounted
                ? showToast(
                    context,
                    child:
                        PillChip(label: Text(context.appLocalizations.deleted)),
                  )
                : null,
          );
    }
  });
}
