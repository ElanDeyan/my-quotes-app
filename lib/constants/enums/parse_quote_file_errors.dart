import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ParseQuoteFileErrors {
  notJsonFormat(0, 'invalid_json_format'),
  notJsonMap(1, 'invalid_json_map'),
  notCaseFieldsAndTypes(2, 'not_cased_fields'),
  noChosenFile(3, 'no_chosen_file');

  const ParseQuoteFileErrors(this.errorCode, this.errorCodeString);

  final int errorCode;
  final String errorCodeString;

  static String localizedErrorMessageOf(
    BuildContext context,
    ParseQuoteFileErrors error,
  ) =>
      switch (error) {
        ParseQuoteFileErrors.noChosenFile =>
          AppLocalizations.of(context)!.parseQuoteFileErrorMessageNoChosenFile,
        ParseQuoteFileErrors.notJsonFormat =>
          AppLocalizations.of(context)!.parseQuoteFileErrorMessageNotJsonFormat,
        ParseQuoteFileErrors.notJsonMap =>
          AppLocalizations.of(context)!.parseQuoteFileErrorMessageNotJsonMap,
        ParseQuoteFileErrors.notCaseFieldsAndTypes =>
          AppLocalizations.of(context)!.parseQuoteFileErrorMessageNotCaseFields,
      };
}
