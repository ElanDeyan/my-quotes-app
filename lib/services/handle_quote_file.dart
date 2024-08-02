import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/services/file_picker.dart';
import 'package:my_quotes/services/parse_quote_file.dart';
import 'package:my_quotes/shared/actions/quotes/show_add_quote_from_file_dialog.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';

Future<void> handleQuoteFile(BuildContext context) async {
  final quoteFile = await getJsonFile();

  if (quoteFile != null) {
    final data = await compute(parseQuoteFile, quoteFile);

    if (data != null) {
      final (:quote, :tags) = data;

      if (context.mounted) {
        await showAddQuoteFromFileDialog(context, quote, tags);
      }
    } else {
      if (context.mounted) {
        showToast(
          context,
          child: PillChip(
            label: Text(AppLocalizations.of(context)!.quoteFileParseError),
          ),
        );
      }
    }
  }
}
