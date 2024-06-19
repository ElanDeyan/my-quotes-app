import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/actions/quotes/show_delete_quote_dialog.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

Future<void> deleteQuote(BuildContext context, Quote quote) async {
  final result = showDeleteQuoteDialog(context, quote);

  result.then((value) {
    if (value == true) {
      final database = Provider.of<DatabaseProvider>(context, listen: false);
      database.removeQuote(quote.id!);
      showToast(
        context,
        child: PillChip(label: Text(AppLocalizations.of(context)!.deleted)),
      );
    }
  });
}
